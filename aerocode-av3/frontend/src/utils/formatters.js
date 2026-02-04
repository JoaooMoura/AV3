export const formatarCargo = (cargo) => {
  if (!cargo) return '';
  return cargo.charAt(0).toUpperCase() + cargo.slice(1).toLowerCase();
};

export const formatarData = (data) => {
  if (!data) return '';
  return new Date(data).toLocaleDateString('pt-BR');
};

export const formatarStatus = (status) => {
  if (!status) return '';
  return status.replace('_', ' ').toUpperCase();
};
