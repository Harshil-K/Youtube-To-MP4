import React, { useState } from 'react';
import './App.css';
//frontend

function App() {
  const [url, setUrl] = useState('');
  const [message, setMessage] = useState('');

  const handleConvert = async () => {
    if (!url) {
      setMessage('Please enter a YouTube URL');
      return;
    }

    setMessage('Converting...');
    try {
      const response = await fetch('/download', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ url })
      });

      if (!response.ok) {
        throw new Error('Failed to convert video. Ensure it’s 1080p');
      }

      const blob = await response.blob();
      const downloadUrl = window.URL.createObjectURL(blob);

      const a = document.createElement('a');
      a.href = downloadUrl;
      a.download = 'video.mp4';
      a.click();
      a.remove();

      setMessage('Download started!');
    } catch (err) {
      setMessage(err.message);
    }
  };

  return (
    <div className="container">
      <h1>YouTube to MP4 Converter</h1>
      <input
        type="text"
        placeholder="Enter YouTube URL"
        value={url}
        onChange={(e) => setUrl(e.target.value)}
      />
      <button onClick={handleConvert}>Convert</button>
      <p className="message">{message}</p>
    </div>
  );
}

export default App;