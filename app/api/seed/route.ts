import { db as supabase } from '@/lib/db'; // Adjust path if necessary
import { v4 as uuidv4 } from 'uuid'; // Import UUID generator

export async function GET() {
  try {
    const products = [
      {
        id: uuidv4(),
        image_url: 'https://uwja77bygk2kgfqe.public.blob.vercel-storage.com/smartphone-gaPvyZW6aww0IhD3dOpaU6gBGILtcJ.webp',
        name: 'Smartphone X Pro',
        price: '999.00',
        inventory_quantity: 150,
        availableAt: new Date().toISOString(), // Store as string
        colors: [  // ✅ Store as an array of objects (JSON)
          { name: "White", hex: "#FFFFFF", image: "https://htmlcolorcodes.com/assets/images/colors/white-color-solid-background-1920x1080.png" },
          { name: "Black", hex: "#000000", image: "https://htmlcolorcodes.com/assets/images/colors/black-color-solid-background-1920x1080.png" }
        ]
      }
    ];

    // ✅ Insert data into Supabase
    const { error } = await supabase
      .from('products')
      .upsert(products, { onConflict: 'id' });

    if (error) {
      throw new Error(error.message);
    }

    // ✅ Fetch the inserted data
    const { data, error: fetchError } = await supabase.from('products').select('*');

    if (fetchError) {
      throw new Error(fetchError.message);
    }

    return new Response(
      JSON.stringify({
        message: 'Database seeded successfully!',
        data, // ✅ Returning inserted data
      }),
      { status: 200 }
    );
  } catch (error: any) {
    console.error(error);
    return new Response(
      JSON.stringify({
        message: 'Error seeding the database.',
        error: error.message,
      }),
      { status: 500 }
    );
  }
}
