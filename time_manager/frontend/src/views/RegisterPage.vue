<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';

export default {
    name: 'RegisterPage',
    setup() {
        const router = useRouter();
        
        // Define reactive data properties
        const username = ref('');
        const email = ref('');
        const password = ref('');
        const role = ref('');
        

        // Registration function
        const register = async () => {
            const user = {
                user: {
                    username: username.value,
                    email: email.value,
                    password: password.value,
                    role: role.value,
                }
            };

            try {
                const response = await fetch('http://localhost/api/register', {
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
                console.log('User registered successfully:', responseData);
                router.push('/login');

                // Clear the form fields
                username.value = '';
                email.value = '';
                password.value = '';
                role.value = '';

            } catch (error) {
                console.error('Error registering user:', error);
                alert('An error occurred while registering. Please try again.');
            }
        };

        return {
            username,
            email,
            password,
            role,
            register,
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
                        Create an account
                    </h1>
                    <form class="space-y-4 md:space-y-6" @submit.prevent="register">
                        <div>
                            <label for="username" class="block mb-2 text-sm font-medium text-gray-900">Username</label>
                            <input v-model="username" type="text" id="username" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5" placeholder="John" required />
                        </div>
                        <div>
                            <label for="email" class="block mb-2 text-sm font-medium text-gray-900">E-mail</label>
                            <input v-model="email" type="email" id="email" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5" placeholder="name@company.com" required />
                        </div>
                        <div>
                            <label for="password" class="block mb-2 text-sm font-medium text-gray-900">Password</label>
                            <input v-model="password" type="password" id="password" placeholder="••••••••" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5" required />
                        </div>
                        <div>
                            <label for="role" class="block mb-2 text-sm font-medium text-gray-900">Role</label>
                            <input v-model="role" type="text" id="role" placeholder="Role" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5" required />
                        </div>
                        <button type="submit" class="w-full text-white bg-primary hover:bg-primary-700 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center">
                            Create an account
                        </button>
                        <p class="text-sm font-light text-gray-500">
                            Already have an account? <router-link to="/login" class="font-medium text-primary-600 hover:underline">Sign in here</router-link>
                        </p>
                    </form>
                </div>
            </div>
        </div>
    </section>
</template>
