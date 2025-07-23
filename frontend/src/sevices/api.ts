import axios from "axios";

const api = axios.create({
    baseURL: 'http://127.0.0.1:3000/api/v1/',
    headers: {
        "Content-Type": "application/json"
    }
})

// request interceptor
api.interceptors.request.use(config => {
    const token = localStorage.getItem('access_token')
    if (token) {
        config.headers['Authorization'] = `Bearer ${token}`;
    }
    return config;
}, error => {
    return Promise.reject(error);
});

// response interceptor
api.interceptors.response.use(response => {
    return response;
}, async error => {
    // get the originalRequest
    const originalRequest = error.config;

    // check if the error was 401 and not retried
    if (error.response && error.response.status === 401 && !originalRequest._retry){
        originalRequest._retry = true;

        try {
            // bind refreshToken
            const refreshToken = localStorage.getItem('refresh_token')
            if (!refreshToken) throw new Error("No refresh token!");
    
            // send request to get a refresh_token from backend
            const response = await axios.get('http://127.0.0.1:3000/api/v1/refresh_token', {
                headers: {
                    Authorization: `Bearer ${refreshToken}`
                }
            });
    
            // newAccessToken
            const newAccessToken = response.data.new_access_token
            localStorage.setItem('access_token', newAccessToken);
    
            // retry originalRequest with new token
            originalRequest.headers['Authorization'] = `Bearer ${newAccessToken}`;
            return api(originalRequest);
        } catch (refreshError) {
            console.error("Token refresh failed", refreshError);
            window.location.href = '/login'
        }
    }
    return Promise.reject(error);
});
  
export default api
