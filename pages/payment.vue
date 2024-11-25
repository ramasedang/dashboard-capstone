<template>
  <div class="min-h-screen bg-gray-50 p-4 md:p-6">
    <div class="max-w-7xl mx-auto">
      <!-- Header -->
      <h1 class="text-3xl font-bold text-center text-gray-800 mb-8">Payment Gateway</h1>
      
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Left Grid: Price and QR Code -->
        <div class="bg-white p-6 rounded-xl shadow-lg border border-gray-100">
          <h2 class="text-2xl font-semibold text-center text-emerald-600">Payment Details</h2>
          
          <!-- Amount Card -->
          <div class="mt-6 p-4 bg-emerald-50 rounded-lg">
            <p class="text-xl text-center text-gray-700">
              Amount: <span class="font-bold text-orange-500">Rp 79,000</span>
            </p>
          </div>
          
          <!-- QR Code Section -->
          <div class="mt-6 space-y-4">
            <div class="flex justify-center">
              <div class="relative">
                <img 
                  src="/public/qr.jpeg" 
                  alt="QR Code" 
                  class="w-64 h-64 rounded-lg shadow-md border-2 border-gray-200"
                />
                <div class="absolute inset-0 bg-black/5 rounded-lg"></div>
              </div>
            </div>
            
            <!-- Payment Instructions -->
            <div class="space-y-2 mt-6">
              <h3 class="font-medium text-gray-700 text-center">Payment Instructions</h3>
              <ol class="text-sm text-gray-600 space-y-2 list-decimal list-inside px-4">
                <li>Open your mobile banking app</li>
                <li>Scan the QR code above</li>
                <li>Confirm the payment amount</li>
                <li>Complete the transaction</li>
              </ol>
            </div>
          </div>
        </div>

        <!-- Right Grid: Input Form -->
        <div class="bg-white p-6 rounded-xl shadow-lg border border-gray-100">
          <h2 class="text-2xl font-semibold text-center text-emerald-600">Payment Confirmation</h2>
          
          <form @submit.prevent="handlePayment" class="mt-6 space-y-6">
            <!-- Email Input -->
            <div class="space-y-1">
              <label for="email" class="block text-sm font-medium text-gray-700">Email Address</label>
              <input
                id="email"
                type="email"
                v-model="form.email"
                required
                placeholder="your@email.com"
                class="block w-full px-4 py-2 rounded-lg border border-gray-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition-colors"
                :class="{ 'border-red-300': formErrors.email }"
              />
              <p v-if="formErrors.email" class="text-sm text-red-600">{{ formErrors.email }}</p>
            </div>

            <!-- Name Input -->
            <div class="space-y-1">
              <label for="name" class="block text-sm font-medium text-gray-700">Full Name</label>
              <input
                id="name"
                type="text"
                v-model="form.name"
                required
                placeholder="John Doe"
                class="block w-full px-4 py-2 rounded-lg border border-gray-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition-colors"
                :class="{ 'border-red-300': formErrors.name }"
              />
              <p v-if="formErrors.name" class="text-sm text-red-600">{{ formErrors.name }}</p>
            </div>

            <!-- Payment Proof Input -->
            <div class="space-y-1">
              <label for="proof" class="block text-sm font-medium text-gray-700">Payment Proof</label>
              <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-lg hover:border-emerald-500 transition-colors">
                <div class="space-y-1 text-center">
                  <svg
                    class="mx-auto h-12 w-12 text-gray-400"
                    stroke="currentColor"
                    fill="none"
                    viewBox="0 0 48 48"
                    aria-hidden="true"
                  >
                    <path
                      d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02"
                      stroke-width="2"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                  <div class="flex text-sm text-gray-600">
                    <label
                      for="file-upload"
                      class="relative cursor-pointer rounded-md font-medium text-emerald-600 hover:text-emerald-500 focus-within:outline-none"
                    >
                      <span>Upload a file</span>
                      <input
                        id="file-upload"
                        type="file"
                        @change="handleFileUpload"
                        accept="image/*"
                        class="sr-only"
                      />
                    </label>
                    <p class="pl-1">or drag and drop</p>
                  </div>
                  <p class="text-xs text-gray-500">PNG, JPG up to 10MB</p>
                </div>
              </div>
              <p v-if="form.proof" class="text-sm text-emerald-600 mt-2">
                Selected file: {{ form.proof.name }}
              </p>
            </div>

            <!-- Submit Button -->
            <button
              type="submit"
              class="w-full py-3 px-4 text-white bg-emerald-600 rounded-lg hover:bg-emerald-700 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:ring-offset-2 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              :disabled="isSubmitting"
            >
              <span v-if="isSubmitting">Processing...</span>
              <span v-else>Confirm Payment</span>
            </button>
          </form>
        </div>
      </div>
    </div>

    <!-- Success Modal -->
    <div v-if="showSuccessModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4">
      <div class="bg-white rounded-xl p-6 max-w-md w-full">
        <div class="text-center">
          <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100">
            <svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
          </div>
          <h3 class="mt-4 text-xl font-medium text-gray-900">Payment Submitted!</h3>
          <p class="mt-2 text-sm text-gray-500">
            Thank you for your payment. Please wait 24 hours for processing.
          </p>
          <button
            @click="showSuccessModal = false"
            class="mt-4 w-full inline-flex justify-center px-4 py-2 text-sm font-medium text-emerald-600 bg-emerald-50 border border-transparent rounded-md hover:bg-emerald-100 focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:ring-emerald-500"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

  
  <script setup>
import { ref, reactive } from 'vue'

// Form data
const form = reactive({
  email: '',
  name: '',
  proof: null
})

// Form errors
const formErrors = reactive({
  email: '',
  name: ''
})

// UI state
const isSubmitting = ref(false)
const showSuccessModal = ref(false)

// Validate email
const validateEmail = (email) => {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return re.test(email)
}

// Handle file upload
const handleFileUpload = (event) => {
  const file = event.target.files[0]
  if (file) {
    if (file.size > 10 * 1024 * 1024) {
      alert('File size must be less than 10MB')
      event.target.value = ''
      return
    }
    form.proof = file
  }
}

// Generate random transaction ID
const generateTransactionId = () => {
  return Math.random().toString(36).substring(2, 15)
}

// Get current date in ddmmyyyy format
const getCurrentDate = () => {
  const now = new Date()
  const day = String(now.getDate()).padStart(2, '0')
  const month = String(now.getMonth() + 1).padStart(2, '0') // Months are zero-based
  const year = now.getFullYear()
  return `${day}${month}${year}`
}

// Handle form submission
const handlePayment = async () => {
  // Reset errors
  formErrors.email = ''
  formErrors.name = ''

  // Validate form
  let isValid = true

  if (!form.email) {
    formErrors.email = 'Email is required'
    isValid = false
  } else if (!validateEmail(form.email)) {
    formErrors.email = 'Please enter a valid email'
    isValid = false
  }

  if (!form.name) {
    formErrors.name = 'Name is required'
    isValid = false
  }

  if (!form.proof) {
    alert('Please upload payment proof')
    isValid = false
  }

  if (!isValid) return

  try {
    isSubmitting.value = true

    // Prepare data for API request
    const transactionId = generateTransactionId()
    const date = getCurrentDate()
    const amount = 79000
    const status = "pending"

    const formData = new FormData()
    formData.append('proof', form.proof)

    // Create query parameters
    const queryParams = new URLSearchParams({
      transaction_id: transactionId,
      date: date,
      name: form.name,
      email: form.email,
      amount: amount,
      status: status
    }).toString()

    // API call with query parameters in URL
    await fetch(`http://100.80.37.91:8000/customer/?${queryParams}`, {
      method: 'POST',
      body: formData
    })

    // Show success modal
    showSuccessModal.value = true

    // Reset form
    form.email = ''
    form.name = ''
    form.proof = null
  } catch (error) {
    alert('An error occurred. Please try again.')
  } finally {
    isSubmitting.value = false
  }
}

</script>
