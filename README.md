# DuoVault — Private 2-Person Real-Time Chat (Vercel + Supabase Free Stack)

## Why This Stack Is 100% Free Forever for 2 People
- **Hosting & Framework**: **Next.js on Vercel Hobby Tier** ($0/mo, 100 GB bandwidth, global HTTPS Edge).
- **Database & Real-Time Sync**: **Supabase Free Tier** ($0/mo, 500 MB PostgreSQL database, 2,000,000 Realtime WebSocket messages/month, 1 GB Media Storage bucket).

## Quick Deployment to Vercel
1. Create a free project at [https://supabase.com](https://supabase.com) and run `supabase/schema.sql` in the SQL Editor.
2. Push this folder to a private GitHub repository and import it into [https://vercel.com](https://vercel.com).
3. Add the environment variables from `.env.example` (`NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, `SECRET_CODE_PERSON_1`, `SECRET_CODE_PERSON_2`) and click **Deploy**.
