import axios from "axios";

const api = await axios.create({
  baseURL: "http://127.0.0.1:3000/api/v1/",
  headers: {
    "Content-Type": 'application/json'
  }
});

// check whether token is expired
const isTokenExpired = (token: string | null): boolean => {
  // if no token, it is still expired
  if (!token) return true;

  try {
    // get token payload to retreive exp
    const payload = JSON.parse(atob(token.split('.')[1]));
  
    const tokenExp = payload.exp
    const currentTime = Date.now() / 1000
  
    const isExpired = tokenExp < currentTime
    return isExpired;
  } catch {
    return true
  }
}

// refresh token
async function refreshAuthToken(): Promise<void> {
  // get the refreshToken from localStorage
  const refreshToken = localStorage.getItem('refresh_token');
  // refresh it if it is expired
  if (isTokenExpired(refreshToken)) {
    console.error('Token expired, trying refresh...');
  };

  try {
    // send request to refresh token in backend
    const response = await axios.get('http://127.0.0.1:3000/api/v1/refresh_token', {
      headers: {
        Authorization: `Bearer ${refreshToken}`
      }
    });
  
    const newAccessToken = response.data.new_access_token
    if (newAccessToken) {
      localStorage.setItem('access_token', newAccessToken);
    }
  } catch (error) {
    console.error('Error refreshing token:', error);
    throw error;
  }
}

// request interceptor
api.interceptors.request.use(
  async (config) => {
    const accessToken = localStorage.getItem('access_token');
    if(accessToken) {
      // ensure token is not expired
      if (!isTokenExpired(accessToken)) {
        // bind access_token to request
        config.headers.Authorization = `Bearer ${accessToken}`;
      } else {
        console.error("Access Token Expired, trying refresh...");
        // refresh token
        await refreshAuthToken();
      }
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
)

// response interceptor
api.interceptors.response.use(
  (response) => {
    return response;
  },
  async (error) => {
    // get originalRequest
    const originalRequest = error.config;
    
    if (error.response && error.response.status === 401 && !originalRequest._retry){
      originalRequest._retry = true;

      try {
        // refresh token
        await refreshAuthToken();
  
        const newToken = localStorage.getItem('access_token')
        if (newToken) {
          originalRequest.headers.Authorization = `Bearer ${newToken}`
          return api(originalRequest)
        }
      } catch (refreshError) {
        console.error('Error refreshing token:', refreshError);

        localStorage.removeItem('access_token');
        localStorage.removeItem('refresh_token');

        window.location.href = '/login';

        return Promise.reject(refreshError);
      }
    }
    return Promise.reject(error)
  }
)

export default api
