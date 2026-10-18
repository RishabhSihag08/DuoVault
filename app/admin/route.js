import { promises as fs } from 'fs';
import path from 'path';

export const dynamic = 'force-dynamic';

export async function GET() {
  const filePath = path.join(process.cwd(), 'public', 'admin.html');
  let html = await fs.readFile(filePath, 'utf-8');

  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.SUPABASE_URL || '';
  const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY || '';
  const code1 = process.env.SECRET_CODE_PERSON_1 || '100509';
  const code2 = process.env.SECRET_CODE_PERSON_2 || '251108';

  const envScript = `
  <script>
    window.DUOVAULT_SERVER_CONFIG = {
      supabaseUrl: ${JSON.stringify(supabaseUrl)},
      supabaseAnonKey: ${JSON.stringify(supabaseKey)},
      code1: ${JSON.stringify(code1)},
      code2: ${JSON.stringify(code2)}
    };
  </script>
  `;

  html = html.replace('</head>', `${envScript}</head>`);

  return new Response(html, {
    headers: {
      'Content-Type': 'text/html; charset=utf-8',
      'Cache-Control': 'no-store, must-revalidate',
    },
  });
}
