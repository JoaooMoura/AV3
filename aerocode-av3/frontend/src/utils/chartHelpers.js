export const getBarColor = (value, data) => {
  const values = data.map((item) => item.etapasAtuais);
  const minEtapas = values.length ? Math.min(...values) : 0;
  const maxEtapas = values.length ? Math.max(...values) : 0;

  const minLightness = 80;
  const maxLightness = 50;
  const HUE = 24; // Laranja
  const SATURATION = 100;

  if (maxEtapas === minEtapas) {
    return `hsl(${HUE}, ${SATURATION}%, 50%)`;
  }

  const percent = (value - minEtapas) / (maxEtapas - minEtapas || 1);
  const lightness = minLightness - percent * (minLightness - maxLightness);
  return `hsl(${HUE}, ${SATURATION}%, ${lightness}%)`;
};
