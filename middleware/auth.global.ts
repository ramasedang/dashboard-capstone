export default defineNuxtRouteMiddleware((to) => {
    if (process.client) {
      const token = localStorage.getItem("token");
  
      // Jika tidak ada token dan mencoba mengakses halaman selain /login dan /payment, arahkan ke login
      if (!token && to.path !== "/login" && to.path !== "/payment") {
        return navigateTo("/login");
      }
  
      // Jika sudah ada token dan mencoba mengakses halaman login, arahkan ke dashboard
      if (token && to.path === "/login") {
        return navigateTo("/dashboard");
      }
    }
  });
  