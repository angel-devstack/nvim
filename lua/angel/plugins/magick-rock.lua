return {
  "vhyrro/luarocks.nvim",
  priority = 1001, -- 🧱 Se carga primero para asegurar que los módulos estén disponibles
  lazy = false, -- ⚠️ Importante: debe cargarse al inicio, no bajo demanda
  opts = {
    rocks = {
      "magick", -- 📦 Paquete necesario para image.nvim, por ejemplo
    },
  },
}
