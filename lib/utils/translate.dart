String translate(String message) {
  switch (message.toUpperCase()) {
    case "SERVICE_IS_NOT_REGISTERED_IN_INVENTORY_PRODUCTS_":
      return "EL SERVICIO NO ESTÁ REGISTRADO EN EL INVENTARIO DE PRODUCTOS";
    case "COLLECT_CHANNEL_NOT_FOUND":
      return "CANAL NO ENCONTRADO";
    case "PROFILE_NOT_FOUND":
      return "Perfil no encontrado";
    default:
      return message;
  }
}
