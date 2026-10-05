# Guía de despliegue en AWS EC2

Esta guía despliega CORE_X como demostración de clase en una sola instancia
EC2. Ejecuta los tres contenedores definidos en el Compose: frontend Nginx,
API FastAPI y PostgreSQL.

> Alcance: es un despliegue HTTP para demostración. No configura dominio,
> HTTPS, balanceador ni alta disponibilidad.

## 1. Crear la instancia

En la consola de EC2 selecciona **Launch instance** con estos valores:

| Opción | Valor recomendado para la demo |
| --- | --- |
| Nombre | `core-x-demo` |
| AMI | Ubuntu Server 24.04 LTS, 64 bits (x86) |
| Tipo | `t3.small` (2 GiB de RAM) |
| Almacenamiento | 20 GiB gp3 |
| Dirección IP pública | Habilitada |
| Par de claves | Crea o selecciona una clave `.pem` |

En el grupo de seguridad agrega únicamente estas reglas de entrada:

| Tipo | Puerto | Origen |
| --- | --- | --- |
| HTTP | 80 | `0.0.0.0/0` |
| SSH | 22 | **My IP** |

No abras los puertos `5432` ni `8000`. La aplicación se verá por el puerto
80; PostgreSQL ya permanece en la red interna de Docker.

Espera a que la instancia esté en estado **Running** y que sus comprobaciones
de estado sean correctas.

## 2. Conectarse por SSH

Desde tu computadora, restringe el permiso de la llave y conéctate usando la
IP pública o DNS público de la instancia:

```bash
chmod 400 ruta/a/tu-llave.pem
ssh -i ruta/a/tu-llave.pem ubuntu@IP_PUBLICA_EC2
```

## 3. Instalar Docker y Docker Compose

Ejecuta estos comandos dentro de la instancia Ubuntu:

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl git
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
```

Sal de la sesión SSH y vuelve a entrar para que el grupo `docker` se aplique.
Comprueba la instalación:

```bash
docker --version
docker compose version
```

## 4. Subir el proyecto y configurar variables

Clona tu repositorio y entra al proyecto:

```bash
git clone URL_DE_TU_REPOSITORIO.git core-x
cd core-x
```

Para la demo, crea un `.env` con valores propios. Sustituye los ejemplos por
contraseñas reales; no subas este archivo al repositorio:

```bash
cp .env.example .env
nano .env
```

Contenido mínimo recomendado:

```dotenv
POSTGRES_USER=postgres
POSTGRES_PASSWORD=una-contrasena-de-demo-no-publica
POSTGRES_DB=noonas_db
SECRET_KEY=una-cadena-larga-aleatoria-para-la-demo
```

Puedes generar un valor para `SECRET_KEY` con:

```bash
openssl rand -hex 32
```

## 5. Construir e iniciar

Desde la raíz del repositorio:

```bash
docker compose up -d --build
docker compose ps
```

Es normal que el primer arranque tarde más: Docker descarga imágenes, crea el
esquema y carga los datos de demostración. Los tres servicios deben aparecer
en ejecución; `api` y `frontend` deben llegar a estado `healthy`.

Comprueba localmente desde la EC2:

```bash
curl http://localhost/api/health/
```

La respuesta esperada contiene `"status":"ok"` y `"database":"reachable"`.

## 6. Abrir la aplicación

En un navegador visita:

```text
http://IP_PUBLICA_EC2
```

Usa el acceso de demostración:

| Usuario | Contraseña |
| --- | --- |
| `admin` | `admin123` |
| `sofia` | `admin123` |
| `repartidor` | `admin123` |

## Operación y diagnóstico

```bash
# Ver servicios
docker compose ps

# Ver logs de todos los servicios
docker compose logs -f

# Ver solo la API o PostgreSQL
docker compose logs -f api
docker compose logs -f db

# Aplicar cambios del repositorio
git pull
docker compose up -d --build

# Detener los contenedores sin borrar la base de datos
docker compose down
```

Para restaurar por completo los datos de muestra:

```bash
docker compose down -v
docker compose up -d --build
```

> `docker compose down -v` borra permanentemente los datos de PostgreSQL de
> esa instancia.

## Problemas frecuentes

| Problema | Revisión |
| --- | --- |
| La URL pública no abre | Confirma la regla HTTP/80 del Security Group y que la instancia tenga IP pública. |
| `docker: permission denied` | Cierra y vuelve a abrir la sesión SSH después de `usermod -aG docker $USER`. |
| API no saludable | Ejecuta `docker compose logs -f api db`. |
| No se aplican nuevos datos demo | Los scripts SQL solo se ejecutan en un volumen nuevo; usa `down -v` únicamente si puedes borrar los datos. |
| Cambió la IP pública | Si detienes/inicias la instancia, puede cambiar; usa una Elastic IP si necesitas conservarla. |

## Referencias

- [Guía oficial de inicio de Amazon EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html)
- [Instalación oficial de Docker Engine en Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
