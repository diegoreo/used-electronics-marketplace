# 📱 Marketplace de Aparatos Electrónicos Usados

Plataforma web tipo marketplace donde usuarios pueden publicar y vender sus aparatos electrónicos de segunda mano con actualizaciones en tiempo real.

## ✨ Características Principales

### 👥 Sistema de Usuarios
- Autenticación segura con **Devise**
- Perfiles de vendedor personalizados
- Gestión de cuenta y configuraciones
- Sistema de favoritos/bookmarks

### 📦 Gestión de Anuncios
- Publicación de productos (aparatos usados)
- Subida de imágenes con **ActiveStorage**
- Categorización por tipo de aparato
- Descripción detallada y especificaciones
- Gestión de condición y disponibilidad

### ⚡ Real-Time Features
- Actualizaciones en vivo con **ActionCable** (WebSockets)
- Notificaciones instantáneas
- Sincronización automática de cambios

### 🔍 Búsqueda y Exploración
- Catálogo completo de productos
- Sistema de búsqueda avanzada
- Filtros por categoría, precio, condición
- Query objects para búsquedas complejas

### 💰 Gestión de Ventas
- Seguimiento de transacciones
- Historial completo de ventas
- Notificaciones por email con **ActionMailer**

### 🌍 Características Adicionales
- **PWA Support** (Progressive Web App)
- **Multi-idioma** (ES/EN) con i18n
- **Background Jobs** con ActiveJob
- **View Components** para UI reutilizable
- **Service Objects** para lógica de negocio
- **Policy Objects** con Pundit para autorización

## 🛠️ Stack Tecnológico

- **Backend:** Ruby on Rails 8.0
- **Base de Datos:** PostgreSQL
- **Autenticación:** Devise
- **Autorización:** Pundit
- **Frontend:** Tailwind CSS, Stimulus
- **JavaScript:** ES6+ con Hotwire/Turbo
- **Real-time:** ActionCable (WebSockets)
- **File Storage:** ActiveStorage
- **Background Jobs:** ActiveJob
- **Email:** ActionMailer
- **Deployment:** Docker + Kamal
- **CI/CD:** GitHub Actions
- **Code Quality:** Rubocop, Brakeman

## 🏗️ Arquitectura

### Clean Architecture Pattern
```
app/
├── channels/        # WebSocket channels
├── components/      # View components reutilizables
├── controllers/     # Controladores MVC
├── jobs/           # Background jobs
├── mailers/        # Email templates
├── models/         # ActiveRecord models
├── policies/       # Pundit authorization
├── queries/        # Query objects para búsquedas
├── services/       # Service objects para lógica
└── views/          # Templates ERB
```

### Concerns Modulares
- `Authentication` - Manejo de sesiones
- `Authorization` - Control de acceso
- `Error` - Manejo de errores
- `Language` - Internacionalización
- `Favoritable` - Sistema de favoritos

## 🧪 Testing

Suite completa de tests con **Minitest**:
- Controller tests
- Model tests  
- Integration tests
- System tests
- Component tests
- Service tests
- Job tests
- Mailer tests

## 📁 Módulos Principales

- **Usuarios** - Registro, login, perfiles
- **Productos** - CRUD, búsqueda, categorías
- **Favoritos** - Sistema de bookmarks
- **Notificaciones** - Email + real-time
- **Admin** - Panel de administración

## 🚀 Características Técnicas Avanzadas

- **WebSockets** para actualizaciones en tiempo real
- **PWA** con service workers y manifest
- **Responsive design** mobile-first
- **Queries optimizadas** PostgreSQL
- **Clean code** con concerns y service objects
- **Docker** containerización
- **CI/CD** automatizado con GitHub Actions
- **Code quality** enforced con Rubocop
- **Security** scanning con Brakeman

## 🎯 Tipo de Proyecto

Marketplace B2C/C2C similar a:
- OLX (clasificados)
- MercadoLibre (marketplace)
- Wallapop (compra-venta usuarios)
- eBay (subastas y venta)

## 👨‍💻 Desarrollado por

**Diego Reyes Olivares**  
Full Stack Ruby on Rails Developer

- GitHub: [@diegoreo](https://github.com/diegoreo)
- Email: diegoreyes.rails@gmail.com
- LinkedIn: [diego-reyes-olivares](https://www.linkedin.com/in/diego-reyes-olivares-899335199)

---

**Estado:** ✅ Proyecto completado para cliente local  
**Tipo:** Sistema comercial marketplace  
**Líneas de código:** ~5,000+  
**Archivos:** 206





require_relative "config/application"

Rails.application.load_tasks
