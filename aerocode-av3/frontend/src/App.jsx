import React, { useState, useEffect } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import HomeLayout from './components/homeLayout';
import Dashboard from './components/Dashboard';
import Funcionario from './components/funcionario';
import Aeronaves from './components/aeronaves';
import Login from './components/Login';
import ProtectedRoute from './components/ProtectedRoute';
import DetalheAeronave from './components/detalheAeronave';
import { loadUser, saveUser, removeUser } from './utils/localStorage';

const ROLES = {
  ADMIN: 'administrador',
  ENGENHEIRO: 'engenheiro',
  OPERADOR: 'operador',
};

function App() {
  const [user, setUser] = useState(() => loadUser());

  useEffect(() => {
    if (user) {
      saveUser(user);
    } else {
      removeUser();
    }
  }, [user]);

  const handleLogin = (userData) => {
    setUser(userData);
  };

  const handleLogout = () => {
    setUser(null);
  };

  return (
    <BrowserRouter>
      <Routes>
        {!user ? (
          <Route path="*" element={<Login onLogin={handleLogin} />} />
        ) : (
          <Route
            path="/"
            element={<HomeLayout user={user} onLogout={handleLogout} />}
          >
            <Route index element={<Navigate to="/dashboard" replace />} />
            <Route
              path="dashboard"
              element={
                <ProtectedRoute
                  user={user}
                  allowedRoles={[ROLES.ADMIN, ROLES.ENGENHEIRO, ROLES.OPERADOR]}
                >
                  <Dashboard user={user} />
                </ProtectedRoute>
              }
            />
            <Route
              path="funcionarios"
              element={
                <ProtectedRoute
                  user={user}
                  allowedRoles={[ROLES.ADMIN, ROLES.ENGENHEIRO]}
                >
                  <Funcionario user={user} />
                </ProtectedRoute>
              }
            />
            <Route
              path="aeronaves"
              element={
                <ProtectedRoute
                  user={user}
                  allowedRoles={[ROLES.ADMIN, ROLES.ENGENHEIRO, ROLES.OPERADOR]}
                >
                  <Aeronaves user={user} />
                </ProtectedRoute>
              }
            />
            <Route
              path="detalheAeronave/:codigo"
              element={<DetalheAeronave user={user} />}
            />
            <Route path="*" element={<Navigate to="/dashboard" replace />} />
          </Route>
        )}
      </Routes>
    </BrowserRouter>
  );
}

export default App;
