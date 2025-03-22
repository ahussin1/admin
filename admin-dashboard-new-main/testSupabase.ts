// testSupabase.ts
import { db } from './lib/db';  // Adjust the path based on your project structure

async function testConnection() {
  try {
    const { data, error } = await db.from('products').select('*').limit(1);
    if (error) {
      console.error('Error testing Supabase connection:', error.message);
    } else {
      console.log('Connected to Supabase:', data);
    }
  } catch (err) {
    console.error('Error:', err);
  }
}

testConnection();
