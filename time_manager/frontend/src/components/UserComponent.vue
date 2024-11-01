<script>
import { ref, onMounted } from "vue";

export default {
  setup() {
    const users = ref([]); 

    const fetchUsers = async () => {
  try {
    // Retrieve the JWT token from localStorage or your preferred storage
    const token = localStorage.getItem('token'); 

    const response = await fetch('http://localhost:4000/api/users', {
      method: 'GET', 
      headers: {
        'Authorization': `Bearer ${token}`, 
        'Content-Type': 'application/json', 
      },
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();

    // Access the array from the data object
    if (data && Array.isArray(data.data)) {
      users.value = data.data; 
    } else {
      console.warn("Fetched data is not valid:", data);
      users.value = []; 
    }

    console.log(users.value); 
  } catch (error) {
    console.error("Error fetching users:", error);
  }
};

// Call fetchUsers on component mount
onMounted(fetchUsers);

return { users }; 
  }
};
</script>



<template>
  <div class="mb-4 p-4">
    <div class="mb-4">
      <h1 class="text-2xl font-bold">
        <!-- Hello, {{ users.length > 0 ? users[0].username : 'Guest' }}! -->
      </h1>
    </div>
    <div>
      <div class="overflow-x-auto h-full">
        <table class="table table-md">
          <thead>
            <tr>
              <th>#</th>
              <th>Name</th>
              <th>Email</th>
              <th>Role</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(user, index) in users" :key="user.id"> 
              <th>{{ index + 1 }}</th>
              <td>{{ user.username }}</td>
              <td>{{ user.email }}</td>
              <td class="capitalize">{{ user.role }}</td>
              <td>
                <div class="flex gap-2">
                  <button class="btn btn-sm"><v-icon name="fa-edit" /></button>
                  <button class="btn btn-sm"><v-icon name="fa-trash" /></button>
                </div>
              </td>
            </tr>
            <tr v-if="users.length === 0">
              <td colspan="5" class="text-center">No users found.</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="w-full">
        <button class="btn w-full mb-1" onclick="addUser.showModal()"><v-icon name="fa-plus" /></button>
        <dialog id="addUser" class="modal">
          <div class="modal-box">
            <form method="dialog">
              <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
            </form>
            <h3 class="text-lg font-bold">Add a new user</h3>
            <label class="input input-bordered flex items-center gap-2 my-4">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="h-4 w-4 opacity-70">
                <path d="M2.5 3A1.5 1.5 0 0 0 1 4.5v.793c.026.009.051.02.076.032L7.674 8.51c.206.1.446.1.652 0l6.598-3.185A.755.755 0 0 1 15 5.293V4.5A1.5 1.5 0 0 0 13.5 3h-11Z" />
                <path d="M15 6.954 8.978 9.86a2.25 2.25 0 0 1-1.956 0L1 6.954V11.5A1.5 1.5 0 0 0 2.5 13h11a1.5 1.5 0 0 0 1.5-1.5V6.954Z" />
              </svg>
              <input type="text" class="grow" placeholder="E-mail" />
            </label>
            <div class="w-full">
              <button class="btn w-full">Add</button>
            </div>
          </div>
        </dialog>
      </div>
    </div>
  </div>
</template>