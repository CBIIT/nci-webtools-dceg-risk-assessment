document.addEventListener('DOMContentLoaded', async () => {
    try {
      const response = await fetch('/api/version-info');
      const data = await response.json();
      document.getElementById('lastUpdatedDate').innerText = data.lastUpdated;
      document.getElementById('releaseVersionNumber').innerText = data.version;
    } catch (error) {
      console.error('Error fetching version info:', error);
    }
  });
  