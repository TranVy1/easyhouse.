/**
 * Revokes every server-side refresh token for the signed-in user before the
 * browser removes its NextAuth cookie. Failure is intentionally non-blocking:
 * the local session must still be cleared when the backend is unavailable.
 */
export async function revokeBackendSession(accessToken: unknown): Promise<void> {
  if (typeof accessToken !== 'string' || accessToken.length === 0) {
    return;
  }

  try {
    await fetch('/api/backend-auth/logout', {
      method: 'POST',
      headers: { Authorization: `Bearer ${accessToken}` },
      credentials: 'same-origin',
      cache: 'no-store',
    });
  } catch (error) {
    console.warn('Could not revoke the server session during logout.', error);
  }
}
