<template>
  <div class="min-h-screen bg-gray-100 flex items-center justify-center">
    <div class="bg-white p-8 rounded-md shadow-md text-center max-w-sm w-full">
      <div class="flex justify-center mb-4">
        <svg class="animate-spin h-8 w-8 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"/>
        </svg>
      </div>
      <h2 class="text-lg font-semibold text-gray-700">Logging you in...</h2>
      <p class="text-sm text-gray-500 mt-2">Please wait while we complete your sign-in with Google.</p>
    </div>
  </div>
</template>

<script>
export default {
  mounted() {
    const urlParams = new URLSearchParams(window.location.search)
    const token = urlParams.get('token')

    if (token) {
      localStorage.setItem('token', token)
      setTimeout(() => {
        this.$router.push('/dashboard') // or wherever the user should go
      }, 2000)
    } else {
      alert('Login failed! Please try again.')
      this.$router.push('/login')
    }
  }
}
</script>

<style scoped>
</style>
