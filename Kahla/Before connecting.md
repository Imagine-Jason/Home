# Kahla API Document

## Server address

There are three servers for Kahla.

| Server Address | Allow Cross-Domain | Limit Cookies | Code Branch | Usage | Corresponding Kahla Client |
|-|-|-|-|-|-|
server.kahla.app | https://web.kahla.app | Yes | master | hosting production version of Kahla server | master |
| staging.server.kahla.app | https://staging.kahla.app | Yes | dev | hosting staging version of the Kahla server | dev |
| dev.server.kahla.app | http://localhost:8001 | No | dev | For Developers Local Debugging Kahla App | Local |

## Database

The database of the staging server and the local debugging server is the same one, and the database may be cleaned regularly, and the data persistence is not guaranteed.

The production Kahla server uses an independent database, and the database will not be cleaned up.

If you are a contributor to Kahla, please note that the debugging API is used in the debugging environment, the staging API is used in the pre-deployment environment, and the production API is used only in the production environment.

## Authentication

Carla's servers use cookie-based authentication. In other words, all cookies must be carried when accessing all APIs that require login privileges.

When Kara's client is running, it must work in the cross-domain address allowed by the target server, otherwise it will not be able to carry cookies.

## Protocol

All of Kara's server communications use the mandatory HTTPS protocol and the HSTS standard.
