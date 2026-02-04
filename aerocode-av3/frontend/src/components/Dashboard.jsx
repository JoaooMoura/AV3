import React, { useState, useEffect, useMemo } from 'react';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Cell,
} from 'recharts';
import { relatorioService } from '../services/api';
import { formatarCargo } from '../utils/formatters';
import { getBarColor } from '../utils/chartHelpers';
import '../styles/dashboard.css';

export default function Dashboard({ user }) {
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    carregarDashboard();
  }, []);

  const carregarDashboard = async () => {
    try {
      setLoading(true);
      setError('');
      const response = await relatorioService.dashboard();
      setStats(response.data);
    } catch (err) {
      console.error('Erro ao carregar dashboard:', err);
      setError('Erro ao carregar dashboard. Verifique a conexão com o servidor.');
    } finally {
      setLoading(false);
    }
  };

  const chartData = useMemo(() => {
    if (!stats?.aeronaves || !Array.isArray(stats.aeronaves)) return [];
    return stats.aeronaves.map((a) => ({
      name: a.modelo,
      etapasAtuais: Number(a.etapasConcluidas || 0),
      etapasTotais: Number(a.etapasTotais || 0),
    }));
  }, [stats]);

  const totalAeronaves = stats?.totalAeronaves || 0;
  const etapasConcluidas = stats?.etapasConcluidas || 0;

  if (loading) {
    return (
      <div className="dashboard-page">
        <div className="dashboard-loading">Carregando dashboard...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="dashboard-page">
        <div className="dashboard-error">{error}</div>
      </div>
    );
  }

  if (!stats) return null;

  return (
    <div className="dashboard-page">
      <header className="dashboard-header">
        <div>
          <h1>Dashboard</h1>
          <p className="dashboard-subtitle">
            Visão geral das aeronaves, etapas e testes.
          </p>
        </div>

        <div className="user-pill">
          <div className="user-avatar">
            {user?.nome ? user.nome.charAt(0).toUpperCase() : 'U'}
          </div>
          <div className="user-info-text">
            <span className="user-name">{user?.nome || 'Colaborador'}</span>
            <span className="user-role">
              {formatarCargo(user?.nivelPermissao) || 'Usuário'}
            </span>
          </div>
        </div>
      </header>

      <main className="dashboard-main">
        <section className="top-cards">
          <div className="top-card primary">
            <span className="top-card-label">Total de Aeronaves</span>
            <span className="top-card-value">{totalAeronaves}</span>
          </div>

          <div className="top-card">
            <span className="top-card-label">Etapas Concluídas</span>
            <span className="top-card-value">{etapasConcluidas}</span>
          </div>

          <div className="top-card">
            <span className="top-card-label">Testes Aprovados</span>
            <span className="top-card-value">{stats.testes?.aprovados || 0}</span>
          </div>

          <div className="top-card warning">
            <span className="top-card-label">Testes Reprovados</span>
            <span className="top-card-value">{stats.testes?.reprovados || 0}</span>
          </div>
        </section>

        <section className="content-grid">
          <div className="chart-section">
            <div className="section-header">
              <h2>Progresso das Aeronaves</h2>
              <span className="section-badge">{chartData.length} modelos</span>
            </div>

            <div className="chart-wrapper">
              {chartData.length === 0 ? (
                <div className="empty-chart">
                  Nenhuma aeronave com etapas cadastradas ainda.
                </div>
              ) : (
                <ResponsiveContainer width="100%" height={380}>
                  <BarChart
                    data={chartData}
                    margin={{ top: 10, right: 30, left: 0, bottom: 10 }}
                  >
                    <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
                    <XAxis
                      dataKey="name"
                      stroke="#4a5568"
                      tick={{ fontSize: 12 }}
                    />
                    <YAxis stroke="#4a5568" tick={{ fontSize: 12 }} />
                    <Tooltip
                      wrapperStyle={{
                        backgroundColor: '#0f172a',
                        border: '1px solid #1e293b',
                        borderRadius: '8px',
                        boxShadow: '0 10px 25px rgba(15,23,42,0.6)',
                      }}
                      contentStyle={{
                        backgroundColor: 'transparent',
                        border: 'none',
                      }}
                      labelStyle={{
                        color: '#e5e7eb',
                        fontWeight: 'bold',
                        marginBottom: 4,
                      }}
                      itemStyle={{
                        color: '#e5e7eb',
                        fontSize: 12,
                      }}
                      formatter={(value) => [`${value}`, 'Etapas concluídas']}
                    />
                    <Bar dataKey="etapasAtuais" radius={[4, 4, 0, 0]}>
                      {chartData.map((entry, index) => (
                        <Cell
                          key={`cell-${index}`}
                          fill={getBarColor(entry.etapasAtuais, chartData)}
                        />
                      ))}
                    </Bar>
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>
          </div>

          <div className="side-panel">
            <h2>Resumo de Etapas</h2>
            <div className="side-metrics">
              <div className="metric-row">
                <span>Etapas Pendentes</span>
                <span className="metric-value pending">
                  {stats.etapas?.pendentes || 0}
                </span>
              </div>
              <div className="metric-row">
                <span>Etapas em Andamento</span>
                <span className="metric-value progress">
                  {stats.etapas?.andamento || 0}
                </span>
              </div>
              <div className="metric-row">
                <span>Etapas Concluídas</span>
                <span className="metric-value done">
                  {stats.etapas?.concluidas || 0}
                </span>
              </div>
            </div>

            <h3 className="side-subtitle">Equipe</h3>
            <div className="side-metrics">
              <div className="metric-row">
                <span>Total de Funcionários</span>
                <span className="metric-value neutral">
                  {stats.totalFuncionarios}
                </span>
              </div>
            </div>
          </div>
        </section>
      </main>
    </div>
  );
}
