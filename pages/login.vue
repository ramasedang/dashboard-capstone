<template>
  <div class="flex items-center justify-center min-h-screen bg-slate-100">
    <div class="w-full max-w-md p-8 bg-slate-50 shadow-lg rounded-lg">
      <h2 class="text-2xl font-semibold text-center text-slate-700">Login</h2>
      <p class="text-center text-slate-500 mb-6">Welcome back! Please login to your account.</p>

      <form @submit.prevent="handleLogin" class="space-y-4">
        <div>
          <label for="email" class="block text-slate-600">Email</label>
          <input
            id="email"
            type="email"
            v-model="form.email"
            placeholder="Enter your email"
            class="block w-full px-4 py-2 mt-1 text-slate-700 bg-slate-100 border border-slate-300 rounded-md focus:ring focus:ring-slate-300 focus:outline-none"
          />
        </div>
        <div>
          <label for="password" class="block text-slate-600">Password</label>
          <input
            id="password"
            type="password"
            v-model="form.password"
            placeholder="Enter your password"
            class="block w-full px-4 py-2 mt-1 text-slate-700 bg-slate-100 border border-slate-300 rounded-md focus:ring focus:ring-slate-300 focus:outline-none"
          />
        </div>
        <button
          type="submit"
          class="w-full px-4 py-2 text-white bg-slate-700 rounded-md hover:bg-slate-800 focus:outline-none focus:ring focus:ring-slate-300"
          :disabled="loading"
        >
          <span v-if="loading" class="spinner"></span>
          <span v-else>Login</span>
        </button>
      </form>

      <p class="mt-4 text-center text-slate-500">
        Don't have an account?
        <a href="/register" class="text-slate-700 hover:underline">Register</a>
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";

const form = ref({
  email: "",
  password: "",
});

const loading = ref(false); // Loading state
const router = useRouter();

const handleLogin = async () => {
  loading.value = true; // Start loading

  try {
    // Send request to backend
    const response = await fetch("http://100.80.37.91:8000/login/", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
      },
      body: JSON.stringify({
        email: form.value.email,
        password: form.value.password,
      }),
    });

    // Handle the response from backend
    if (response.ok) {
      const data = await response.json();
      localStorage.setItem("token", data.access_token);
      router.push("/dashboard"); // Redirect to the dashboard
    } else {
      const errorData = await response.json();
      alert(`Login failed: ${errorData.detail || "Unknown error"}`);
    }
  } catch (error) {
    alert(`An error occurred: ${error.message}`);
  } finally {
    loading.value = false; // Stop loading
  }
};
</script>

<style scoped>
/* Add styles for the spinner */
.spinner {
  border: 2px solid transparent;
  border-top: 2px solid #fff;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

/* Add this to center the page content */
html,
body {
  height: 100%;
  margin: 0;
}

#app {
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>
