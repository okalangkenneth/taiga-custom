version: '3.8'
services:
  db:
    image: 'postgres:13'
    container_name: taiga-back
    environment:
      POSTGRES_DB: taiga
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: 8sZ1gHvoFg3RYOUONIPP6UoJRqLTliGRDiZzuwCDd6haRSaDNB7vTcovvtaTBMzR
    volumes:
      - 'taiga-db-data:/var/lib/postgresql/data'
    networks:
      - taiga-network
          ipv4_address: 172.20.0.2

  redis:
    image: 'redis:6'
    container_name: taiga-redis
    networks:
      - taiga-network
          ipv4_address: 172.20.0.2

  back:
    image: 'taigaio/taiga-back:latest'
    container_name: taiga-back
    depends_on:
      - db
      - redis
    environment:
      POSTGRES_DB: taiga
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: 8sZ1gHvoFg3RYOUONIPP6UoJRqLTliGRDiZzuwCDd6haRSaDNB7vTcovvtaTBMzR
      POSTGRES_HOST: taiga-db
      POSTGRES_PORT: 5432
      REDIS_HOST: ipv4_address: 172.20.0.2
      REDIS_PORT: 6379
      TAIGA_SECRET_KEY: Y8o^j2Mv#r6@L1qZ&pXpR9z!UwT$kFbNc0EsBh4dgW*Jx7AYmC
      TAIGA_SITES_SCHEME: http
      TAIGA_SITES_DOMAIN: 95.217.187.120
      EMAIL_BACKEND: console
      TAIGA_ADMIN_USERNAME: admin
      TAIGA_ADMIN_PASSWORD: admin_password
      TAIGA_ADMIN_EMAIL: admin@example.com
    volumes:
      - 'taiga-media:/taiga-back/media'
      - 'taiga-static:/taiga-back/static'
    networks:
      - taiga-network
          ipv4_address: 172.20.0.4

  front:
    image: 'taigaio/taiga-front:latest'
    container_name: taiga-front
    depends_on:
      - back
    environment:
      TAIGA_API_URL: 'http://taiga-back:8000/api/v1/'
      TAIGA_WEBSOCKETS_URL: 'ws://taiga-back:8000/events'
    networks:
      - taiga-network
          ipv4_address: 172.20.0.5

  # Add a reverse proxy
  nginx:
    image: 'nginx:alpine'
    container_name: taiga-nginx
    depends_on:
      - front
      - back
    ports:
      - '80:80'  # This is the only exposed port
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    networks:
      - taiga-network

networks:
  taiga-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16

volumes:
  taiga-db-data:
  taiga-media:
  taiga-static:
