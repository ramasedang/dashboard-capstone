<template>
    <div class="min-h-screen bg-gray-50">
        <!-- Header -->
        <header class="bg-[#1B2535] text-white py-4 sticky top-0 z-50 shadow-md">
            <div class="container mx-auto flex justify-between items-center px-4">
                <div class="flex items-center space-x-4">
                    <h1 class="text-2xl font-semibold">Payment Dashboard</h1>
                    <span class="bg-[#2BA829] px-3 py-1 rounded-full text-sm">Admin Panel</span>
                </div>
                <div class="flex items-center space-x-4">
                    <span class="text-sm">Welcome, Admin</span>
                    <button @click="logout"
                        class="bg-red-600 px-6 py-2 rounded-lg text-sm font-medium hover:bg-red-700 focus:ring-4 focus:ring-red-300 transition flex items-center space-x-2">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24"
                            stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                        </svg>
                        <span>Logout</span>
                    </button>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="container mx-auto py-6 px-4">
            <!-- Stats Cards -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center justify-between">
                        <h3 class="text-gray-500 text-sm">Total Transactions</h3>
                        <span
                            class="bg-[#FA7513] text-white text-xs font-medium px-2.5 py-0.5 rounded-full">Today</span>
                    </div>
                    <p class="text-2xl font-bold text-[#1B2535] mt-2">{{ totalTransactions }}</p>
                </div>
                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center justify-between">
                        <h3 class="text-gray-500 text-sm">Verified Payments</h3>
                        <span
                            class="bg-[#2BA829] text-white text-xs font-medium px-2.5 py-0.5 rounded-full">Active</span>
                    </div>
                    <p class="text-2xl font-bold text-[#1B2535] mt-2">{{ verifiedPayments }}</p>
                </div>
                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center justify-between">
                        <h3 class="text-gray-500 text-sm">Pending Verification</h3>
                        <span
                            class="bg-[#566459] text-white text-xs font-medium px-2.5 py-0.5 rounded-full">Pending</span>
                    </div>
                    <p class="text-2xl font-bold text-[#1B2535] mt-2">{{ pendingPayments }}</p>
                </div>
                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center justify-between">
                        <h3 class="text-gray-500 text-sm">Total Amount</h3>
                        <span
                            class="bg-[#2BA829] text-white text-xs font-medium px-2.5 py-0.5 rounded-full">Revenue</span>
                    </div>
                    <p class="text-2xl font-bold text-[#1B2535] mt-2">Rp {{ totalAmount.toLocaleString() }}</p>
                </div>
            </div>

            <!-- Search and Filter -->
            <div class="bg-white rounded-lg shadow-lg p-4 mb-6">
                <div
                    class="flex flex-col md:flex-row md:items-center md:justify-between space-y-4 md:space-y-0 md:space-x-4">
                    <div class="flex-1">
                        <input type="text" v-model="searchQuery"
                            placeholder="Search by name, email or transaction ID..."
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#2BA829] focus:border-[#2BA829]">
                    </div>
                    <div class="flex space-x-4">
                        <select v-model="filterStatus"
                            class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#2BA829] focus:border-[#2BA829]">
                            <option value="">All Status</option>
                            <option value="verified">Verified</option>
                            <option value="pending">Pending</option>
                            <option value="rejected">Rejected</option>
                        </select>
                        <button @click="fetchData"
                            class="px-4 py-2 bg-[#FA7513] text-white rounded-lg hover:bg-[#FA7513]/80 focus:ring-4 focus:ring-[#FA7513]/50">
                            Refresh
                        </button>
                    </div>
                </div>
            </div>

            <!-- Payment Table -->
            <div class="overflow-x-auto bg-white rounded-lg shadow-lg">
                <table class="min-w-full table-auto text-sm text-left text-gray-500">
                    <thead class="bg-[#223D29] text-white">
                        <tr>
                            <th class="px-6 py-3">Transaction ID</th>
                            <th class="px-6 py-3">Date</th>
                            <th class="px-6 py-3">Name</th>
                            <th class="px-6 py-3">Email</th>
                            <th class="px-6 py-3">Amount</th>
                            <th class="px-6 py-3">Payment Proof</th>
                            <th class="px-6 py-3">Status</th>
                            <th class="px-6 py-3">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="payment in filteredPayments" :key="payment.id" class="border-b hover:bg-slate-50">
                            <td class="px-6 py-4 font-medium text-gray-900">{{ payment.transaction_id }}</td>
                            <td class="px-6 py-4 text-gray-900">{{ payment.date }}</td>
                            <td class="px-6 py-4 text-gray-900">{{ payment.name }}</td>
                            <td class="px-6 py-4 text-gray-900">{{ payment.email }}</td>
                            <td class="px-6 py-4 text-gray-900">Rp {{ payment.amount.toLocaleString() }}</td>
                            <td class="px-6 py-4">
                                <button @click="viewProof(payment)"
                                    class="text-[#FA7513] hover:text-[#FA7513]/80 underline">
                                    View Proof
                                </button>
                            </td>
                            <td class="px-6 py-4">
                                <span :class="{
                                    'bg-[#2BA829] text-white': payment.status === 'verified',
                                    'bg-[#566459] text-white': payment.status === 'pending',
                                    'bg-red-100 text-red-800': payment.status === 'rejected'
                                }" class="px-2.5 py-0.5 rounded-full text-xs font-medium">
                                    {{ payment.status.charAt(0).toUpperCase() + payment.status.slice(1) }}
                                </span>
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex space-x-2">
                                    <button v-if="payment.status === 'pending'" @click="verifyPayment(payment)"
                                        class="text-green-600 hover:text-green-800" title="Verify">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
                                            viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M5 13l4 4L19 7" />
                                        </svg>
                                    </button>
                                    <button v-if="payment.status !== 'rejected'" @click="rejectPayment(payment)"
                                        class="text-red-600 hover:text-red-800" title="Reject">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
                                            viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M6 18L18 6M6 6l12 12" />
                                        </svg>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Payment Proof Modal -->
            <div v-if="showModal" class="fixed inset-0 bg-gray-500 bg-opacity-50 flex justify-center items-center z-50">
                <div class="bg-white p-6 rounded-lg shadow-lg max-w-lg w-full">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="text-lg font-semibold">Payment Proof for Transaction {{
                            selectedPayment.transaction_id }}</h3>
                        <button @click="closeModal" class="text-gray-500 hover:text-gray-700">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M6 18L18 6M6 6l12 12" />
                            </svg>
                        </button>
                    </div>
                    <div class="relative min-h-[300px] flex items-center justify-center">
                        <img v-if="proofImageUrl" :src="proofImageUrl" alt="Payment Proof"
                            class="max-w-full max-h-[500px] object-contain" @error="handleImageError">
                        <div v-if="imageLoading" class="absolute inset-0 flex items-center justify-center">
                            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-[#2BA829]"></div>
                        </div>
                        <div v-if="imageError" class="text-red-600 text-center">
                            Failed to load image
                        </div>
                    </div>
                    <div class="flex justify-end mt-4 space-x-2">
                        <button @click="downloadProof"
                            class="bg-[#2BA829] text-white px-4 py-2 rounded-lg hover:bg-[#2BA829]/80 focus:ring-4 focus:ring-[#2BA829]/50">
                            Download
                        </button>
                        <button @click="closeModal"
                            class="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 focus:ring-4 focus:ring-red-300">
                            Close
                        </button>
                    </div>
                </div>
            </div>
        </main>
    </div>
</template>

<script>
export default {
    data() {
        return {
            searchQuery: '',
            filterStatus: '',
            payments: [],
            selectedPayment: null,
            showModal: false,
            proofImageUrl: null,
            imageLoading: false,
            imageError: false
        };
    },
    computed: {
        filteredPayments() {
            return this.payments.filter(payment => {
                const searchLower = this.searchQuery.toLowerCase();
                return (
                    (this.searchQuery ?
                        payment.name.toLowerCase().includes(searchLower) ||
                        payment.email.toLowerCase().includes(searchLower) ||
                        payment.transaction_id.toLowerCase().includes(searchLower)
                        : true) &&
                    (this.filterStatus ? payment.status === this.filterStatus : true)
                );
            });
        },
        totalTransactions() {
            return this.payments.length;
        },
        verifiedPayments() {
            return this.payments.filter(payment => payment.status === 'verified').length;
        },
        pendingPayments() {
            return this.payments.filter(payment => payment.status === 'pending').length;
        },
        totalAmount() {
            return this.payments.reduce((total, payment) => total + payment.amount, 0);
        }
    },
    methods: {
        async fetchData() {
            try {
                const response = await fetch('http://100.80.37.91:8000/customers/', {
                    headers: {
                        'accept': 'application/json',
                        'Authorization': `Bearer ${this.getToken()}`
                    }
                });
                if (response.ok) {
                    this.payments = await response.json();
                } else {
                    console.error('Failed to fetch data');
                    if (response.status === 401) {
                        this.redirectToLogin();
                    }
                }
            } catch (error) {
                console.error('Error fetching data:', error);
            }
        },

        async viewProof(payment) {
            this.selectedPayment = payment;
            this.showModal = true;
            this.imageLoading = true;
            this.imageError = false;
            this.proofImageUrl = null;

            try {
                const response = await fetch(`http://100.80.37.91:8000/payments/${payment.transaction_id}/proof`, {
                    headers: {
                        'Authorization': `Bearer ${this.getToken()}`
                    }
                });

                if (response.ok) {
                    const blob = await response.blob();
                    // Revoke the old URL to prevent memory leaks
                    if (this.proofImageUrl) {
                        URL.revokeObjectURL(this.proofImageUrl);
                    }
                    // Create a new blob URL// Create a new blob URL
                    this.proofImageUrl = URL.createObjectURL(blob);
                } else {
                    this.imageError = true;
                    console.error('Failed to fetch payment proof');
                }
            } catch (error) {
                this.imageError = true;
                console.error('Error fetching payment proof:', error);
            } finally {
                this.imageLoading = false;
            }
        },

        handleImageError() {
            this.imageError = true;
            this.imageLoading = false;
        },

        async downloadProof() {
            if (!this.proofImageUrl || !this.selectedPayment) return;

            try {
                const response = await fetch(this.proofImageUrl);
                const blob = await response.blob();
                const url = window.URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = `proof_${this.selectedPayment.transaction_id}.jpg`;
                document.body.appendChild(a);
                a.click();
                window.URL.revokeObjectURL(url);
                document.body.removeChild(a);
            } catch (error) {
                console.error('Error downloading proof:', error);
            }
        },

        getToken() {
            if (process.client) {
                return localStorage.getItem('token');
            }
            return null;
        },

        checkTokenExpiration() {
            if (process.client) {
                const token = this.getToken();
                if (token) {
                    const payload = JSON.parse(atob(token.split('.')[1]));
                    const currentTime = Math.floor(Date.now() / 1000);
                    if (payload.exp < currentTime) {
                        this.redirectToLogin();
                    }
                } else {
                    this.redirectToLogin();
                }
            }
        },

        redirectToLogin() {
            if (process.client) {
                localStorage.removeItem('token');
            }
            this.$router.push('/login');
        },

        logout() {
            this.redirectToLogin();
        },

        closeModal() {
            this.showModal = false;
            this.selectedPayment = null;
            if (this.proofImageUrl) {
                URL.revokeObjectURL(this.proofImageUrl);
                this.proofImageUrl = null;
            }
            this.imageError = false;
            this.imageLoading = false;
        },

        async verifyPayment(payment) {
            try {
                const response = await fetch(`http://100.80.37.91:8000/customers/${payment.transaction_id}/status`, {
                    method: 'PUT',
                    headers: {
                        'Accept': 'application/json',
                        'Authorization': `Bearer ${this.getToken()}`,
                        'Content-Type': 'application/json'  // Ensure content-type is set to JSON
                    },
                    body: JSON.stringify({
                        status: 'verified'  // Send the 'status' field with the value 'verified'
                    })
                });
                if (response.ok) {
                    this.fetchData(); // Refresh the data
                } else {
                    console.error('Verification failed');
                }
            } catch (error) {
                console.error('Error verifying payment:', error);
            }
        },

        async rejectPayment(payment) {
            try {
                const response = await fetch(`http://100.80.37.91:8000/customers/${payment.transaction_id}/status`, {
                    method: 'PUT',
                    headers: {
                        'Accept': 'application/json',
                        'Authorization': `Bearer ${this.getToken()}`,
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        status: 'pending'  // Only sending the status in the request body
                    })
                });
                if (response.ok) {
                    this.fetchData(); // Refresh the data
                } else {
                    console.error('Rejection failed');
                }
            } catch (error) {
                console.error('Error rejecting payment:', error);
            }
        }


    },

    created() {
        this.checkTokenExpiration();
        this.fetchData();
    },
    beforeUnmount() {
        // Cleanup any existing blob URLs
        if (this.proofImageUrl) {
            URL.revokeObjectURL(this.proofImageUrl);
        }
    }
};
</script>