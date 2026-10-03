export const PRODUCT_PRICES: Record<string, number> = {
  'Sauce Labs Backpack': 29.99,
  'Sauce Labs Bike Light': 9.99,
  'Sauce Labs Bolt T-Shirt': 15.99,
  'Sauce Labs Fleece Jacket': 49.99,
  'Sauce Labs Onesie': 7.99,
  'Test.allTheThings() T-Shirt (Red)': 15.99
};

export function priceOf(product: string): number {
  const price = PRODUCT_PRICES[product];
  if (price === undefined) {
    throw new Error(`Producto desconocido en el catalogo de pruebas: "${product}"`);
  }
  return price;
}
