# CORE_X — Sistema de gestión de pastelería

El proyecto se ejecuta íntegramente con Docker Compose: frontend estático en
Nginx, API FastAPI y PostgreSQL. Nginx publica el frontend y redirige
internamente `/api` y `/media` a la API, por lo que no hay que configurar URLs
del navegador.

## Arranque rápido

Desde la raíz del proyecto:

```bash
docker compose up --build
```

Abre <http://localhost> en el navegador. La API queda disponible en
<http://localhost:8000> y su comprobación de estado en
<http://localhost:8000/api/health/>.

En el primer arranque PostgreSQL crea automáticamente el esquema con
`app/db/create.sql` y carga las demostraciones de `app/db/populate.sql`.
El acceso inicial es usuario `admin` y contraseña `admin123`.

## Servicios

| Servicio | Dirección publicada | Función |
| --- | --- | --- |
| `frontend` | `http://localhost` | Nginx, archivos estáticos y proxy inverso |
| `api` | `http://localhost:8000` | FastAPI |
| `db` | Solo red interna Docker | PostgreSQL 15 |

La API no inicia hasta que PostgreSQL responde a `pg_isready`; el frontend
espera a que la API pase su healthcheck.

## Variables opcionales

El Compose tiene valores de desarrollo incorporados, de modo que no necesitas
un archivo `.env` para el arranque rápido. Para reemplazarlos, crea
`.env` a partir de `.env.example` antes de levantar los servicios:

```bash
cp .env.example .env
```

En un despliegue público, define al menos `POSTGRES_PASSWORD` y `SECRET_KEY`
con valores seguros.

## Reiniciar los datos de demostración

Los scripts SQL de inicialización de PostgreSQL se ejecutan únicamente cuando
el volumen de datos es nuevo. Para eliminar todos los datos locales y volver a
crear el esquema actualizado y los datos de muestra:

```bash
docker compose down -v
docker compose up --build
```

> `down -v` borra permanentemente los datos de la base local.

## Operación diaria

```bash
docker compose up -d --build
docker compose ps
docker compose logs -f api
docker compose down
```

El frontend se entrega desde `frontend/`; no necesita servidor local adicional.

## Estructura del frontend

```text
frontend/
├── index.html          # Inicio de sesión
├── pages/              # Menús y pantallas de la aplicación
├── assets/
│   ├── css/
│   ├── images/
│   └── js/
├── nginx.conf
└── Dockerfile
```

Nginx conserva compatibilidad con las rutas antiguas de las páginas mientras
se usan enlaces y marcadores existentes.

## Despliegue

Para publicar la demostración en una instancia EC2, consulta la
[guía de despliegue en EC2](docs/despliegue-ec2.md).
"# noonas_final" 
