const MINIMUM_SECRET_LENGTH = 32;

export function requireNextAuthSecret(): string {
  const secret = process.env.NEXTAUTH_SECRET;

  if (!secret || secret.length < MINIMUM_SECRET_LENGTH) {
    throw new Error(
      'NEXTAUTH_SECRET must be configured with at least 32 characters before starting the application.'
    );
  }

  return secret;
}

export function sessionCookie(name: string) {
  const secure = process.env.NODE_ENV === 'production';

  return {
    name: secure ? `__Host-${name}` : name,
    options: {
      httpOnly: true,
      sameSite: 'lax' as const,
      path: '/',
      secure,
    },
  };
}
