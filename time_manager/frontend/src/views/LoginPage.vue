<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';

export default {
    name: 'LoginPage',
    setup() {
        const router = useRouter();
        const email = ref('');
        const password = ref('');

        const login = async (event) => {
            event.preventDefault();

            const user = {
                email: email.value,
                password: password.value,
            };

            try {
                const response = await fetch('http://localhost:4000/api/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(user),
                });

                if (!response.ok) {
                    const errorData = await response.json();
                    alert(`Error: ${errorData.message}`);
                    return;
                }

                const responseData = await response.json();
                console.log('User logged in successfully:', responseData);
                localStorage.setItem('token', responseData.jwt);
                localStorage.setItem('userID', responseData.userid);
                localStorage.setItem('role', responseData.role);
                localStorage.setItem('username', responseData.username);
                localStorage.setItem('email', responseData.email);
                router.push('/'); 

                email.value = '';
                password.value = '';

            } catch (error) {
                console.error('Error logging in user:', error);
                alert('An error occurred while logging in. Please try again.');
            }
        };

        return {
            email,
            password,
            login,
        };
    },
};
</script>

<template>
<section class="bg-gray-50">
  <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
      <a href="#" class="flex items-center mb-6 text-2xl font-semibold text-gray-900">
          <img class="h-12 mr-2 fill-primary" src="../../public/logo.png" alt="logo">
          Time Manager
      </a>
      <div class="w-full bg-white rounded-lg shadow md:mt-0 sm:max-w-md xl:p-0">
          <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
              <h1 class="text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl">
                  Sign in to your account
              </h1>
              <form class="space-y-4 md:space-y-6" @submit="login">
                  <div>
                      <label for="email" class="block mb-2 text-sm font-medium text-gray-900">E-mail</label>
                      <input 
                          type="email" 
                          name="email" 
                          id="email" 
                          v-model="email"  
                          class="bg-gray-50 border border-gray-300 text-gray-900 rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5" 
                          placeholder="name@company.com" 
                          required>
                  </div>
                  <div>
                      <label for="password" class="block mb-2 text-sm font-medium text-gray-900">Password</label>
                      <input 
                          type="password" 
                          name="password" 
                          id="password" 
                          v-model="password"  
                          placeholder="••••••••" 
                          class="bg-gray-50 border border-gray-300 text-gray-900 rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5" 
                          required>
                  </div>
                  <button type="submit" class="w-full text-white bg-primary hover:bg-primary-700 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center">Sign in</button>
                  <p class="text-sm font-light text-gray-500">
                      Don’t have an account yet? <router-link to="/register" class="font-medium text-primary-600 hover:underline">Sign up here</router-link>
                  </p>
              </form>
          </div>
      </div>
  </div>
</section>
</template>
