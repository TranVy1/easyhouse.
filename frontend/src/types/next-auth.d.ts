import 'next-auth';
import { DefaultSession } from 'next-auth';

declare module 'next-auth' {
  /**
   * Returned by `useSession`, `getSession` and received as a prop on the `SessionProvider` React Context
   */
  interface Session {
    user: {
      /** The user's postal address. */
      id?: string;
      role?: string;
      phone?: string;
      avatar?: string;
    } & DefaultSession['user'];
    accessToken?: unknown;
  }

  interface User {
    id?: string;
    role?: string;
    phone?: string;
    avatar?: string;
    accessToken?: unknown;
  }
}

declare module 'next-auth/jwt' {
  /** Returned by the `jwt` callback and `getToken`, when using JWT sessions */
  interface JWT {
    role?: string;
    phone?: string;
    avatar?: string;
    accessToken?: unknown;
  }
}
