import { createClient } from '@supabase/supabase-js';

// Ensure environment variables are loaded
const supabaseUrl = process.env.SUPABASE_URL || '';
const supabaseKey = process.env.SUPABASE_ANON_KEY || '';

if (!supabaseUrl || !supabaseKey) {
  throw new Error('Missing Supabase URL or Key in environment variables.');
}

// Initialize Supabase client
export const db = createClient(supabaseUrl, supabaseKey);

// Define the type for products (match your actual schema)
export interface Item {
  id: number;
  name: string;
  description: string;
  price: number;
  created_at: string;  // Ensure this is stored as a string or Date
  image_url: string;
  category_id: string;
  inventory_quantity: number;
  coupon_id: string | null;
  status: string;
  availableAt: Date;
}

// Fetch products with search and pagination
export async function getProducts(
  search: string,
  offset: number
): Promise<{
  products: Item[];
  newOffset: number | null;
  totalProducts: number;
}> {
  let query = db
    .from('products')
    .select('*', { count: 'exact' })
    .range(offset, offset + 4); // Pagination: 5 items per page

  // Apply search filter if a search term is provided
  if (search) {
    query = query.ilike('name', `%${search}%`);  // Case-insensitive search for product name
  }

  const { data, error, count } = await query;

  if (error) {
    throw new Error(`Error fetching products: ${error.message}`);
  }

  if (!Array.isArray(data)) {
    throw new Error("Expected data to be an array, but got a different type.");
  }

  // Ensure created_at is properly formatted
  const formattedProducts = data.map((product) => ({
    ...product,
    created_at: product.created_at
      ? new Date(product.created_at).toLocaleDateString("en-US")
      : 'N/A', // Fallback if created_at is missing
  }));

  return {
    products: formattedProducts,
    newOffset: data.length >= 5 ? offset + 5 : null,
    totalProducts: count || 0,
  };
}

// Add a new product
export async function addProduct(product: Item): Promise<Item | null> {
  const { data, error } = await db
    .from('products')
    .insert([product])
    .select()
    .maybeSingle();  // Fetch single record instead of an array

  if (error) {
    throw new Error(`Error adding product: ${error.message}`);
  }

  return data || null;
}
