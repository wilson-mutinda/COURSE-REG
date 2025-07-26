import axios from "axios";

const api = axios.create({
  baseURL: "http://127.0.0.1:3000/api/v1/",
  headers: {
    "Content-Type": "application/json"
  }
});

// checks whether any required token is expired
const isTokenExpired = (token: string | null): boolean => {
  if (!token) return true
  try {
    const payload = JSON.parse(atob(token.split('.')[1]));
  
    const tokenExp = payload.exp 
    const currentTime = Date.now() / 1000
  
    const isExpired = tokenExp < currentTime
    return isExpired
  } catch {
    return true
  }
}

// refresh token
async function refreshAuthToken(): Promise<boolean>{
  const refreshToken = localStorage.getItem('refresh_token')
  if (!refreshToken || isTokenExpired(refreshToken)){
    console.error('Refresh token is expired or missing');

    localStorage.removeItem('access_token');
    localStorage.removeItem('refresh_token');

    // window.location.href = '/login';
    return false;
  }
  try {
    // send request to backend to refresh token
    const response = await axios.get('http://127.0.0.1:3000/api/v1/refresh_token', {
      headers: {
        Authorization: `Bearer ${refreshToken}`
      }
    });
  
    const newAccessToken = response.data.new_access_token
    if (newAccessToken) {
      localStorage.setItem('access_token', newAccessToken);
      return true
    }
    throw new Error('Invalid token response')
  } catch (error) {
    console.error('Failed to refresh token:', error);

    localStorage.removeItem('refresh_token');
    localStorage.removeItem('access_token');

    window.location.href = '/login'
    return false
  }

}

// request interceptors
api.interceptors.request.use(
  async (config) => {
    const accessToken = localStorage.getItem('access_token');
    if (accessToken) {
      // ensure token is not expired
      if (!isTokenExpired(accessToken)) {
        config.headers.Authorization = `Bearer ${accessToken}`;
      } else {
        console.error('Access Token Expired. Trying refresh...');
        // refresh Token
        await refreshAuthToken()
        const newToken = localStorage.getItem('access_token')
        if (newToken) {
          config.headers.Authorization = `Bearer ${newToken}`;
        }
      }
    }
    return config;
  },
  (error) => {
    return Promise.reject(error)
  }
)

// response interceptors
api.interceptors.response.use(
  (response) => {
    return response;
  },
  async (error) => {
    // get the originalRequest
    const originalRequest = error.config;
    if (error.response && error.response.status === 401 && !originalRequest._retry) {
      const errorMessage = error.response.data?.message || error.response.data?.error || '';
      if (typeof errorMessage === 'string' && (errorMessage.includes('Token Expired') || errorMessage.includes('Unauthorized'))) {
        originalRequest._retry = true;

        try {
          // refresh token
          await refreshAuthToken();
          const newAccess = localStorage.getItem('access_token');
          if (newAccess) {
            originalRequest.headers.Authorization = `Bearer ${newAccess}`;
            return api(originalRequest);
          }
        } catch (refreshError) {
          console.error('REfresh failed:', refreshError);

          localStorage.removeItem('refresh_token');
          localStorage.removeItem('access_token');

          window.location.href = '/login';
          return Promise.reject(refreshError);
        }
      }
    }
    return Promise.reject(error);
  }
);

export default api
