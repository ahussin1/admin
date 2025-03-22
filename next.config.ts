/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStringMode: false,
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'avatars.githubusercontent.com',
        search: ''
      },
      {
        protocol: 'https',
        hostname: '*.public.blob.vercel-storage.com',
        search: ''
      },
      {
        protocol: 'https',
        hostname: '*.supabase.co', // Correct Supabase domain
        search: '',
        pathname: '/storage/v1/**',
      }
    ]
  },
  env: {
    SUPABASE_URL: process.env.SUPABASE_URL,
    SUPABASE_KEY: process.env.SUPABASE_ANON_KEY,
  }
};

module.exports = nextConfig;