import NextAuth from "next-auth";
import { authTenantOptions } from "@/lib/auth-tenant";

const handler = NextAuth(authTenantOptions);

export { handler as GET, handler as POST };
