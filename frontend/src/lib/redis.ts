import Redis from 'ioredis';

const redisUrl = process.env.REDIS_URL || 'redis://localhost:6379';

const getRedisClient = () => {
  if (process.env.NODE_ENV === 'production') {
    return new Redis(redisUrl);
  } else {
    // In development, prevent multiple instances caused by hot reloading
    if (!global.redisClient) {
      global.redisClient = new Redis(redisUrl);
    }
    return global.redisClient;
  }
};

export const redis = getRedisClient();

declare global {
  // eslint-disable-next-line no-var
  var redisClient: Redis | undefined;
}
