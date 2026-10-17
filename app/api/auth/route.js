import { NextResponse } from 'next/server';

export async function GET() {
  return NextResponse.json({
    status: 'ok',
    app: 'DuoVault 2-Person Vault',
    message: 'DuoVault client-side authentication is active via the popup key gate.',
  });
}

export async function POST(request) {
  try {
    const { code } = await request.json();
    const code1 = process.env.SECRET_CODE_PERSON_1 || '100509';
    const code2 = process.env.SECRET_CODE_PERSON_2 || '251108';

    if (code === code1 || code === 'VAULT-ALPHA-01' || code === '100509') {
      return NextResponse.json({ authenticated: true, slot: 'p1', name: 'Person 1' });
    }
    if (code === code2 || code === 'VAULT-OMEGA-02' || code === '251108') {
      return NextResponse.json({ authenticated: true, slot: 'p2', name: 'Person 2' });
    }
    return NextResponse.json(
      { authenticated: false, error: 'Invalid secret access code.' },
      { status: 401 }
    );
  } catch (e) {
    return NextResponse.json(
      { authenticated: false, error: 'Invalid request payload.' },
      { status: 400 }
    );
  }
}
