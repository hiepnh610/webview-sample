import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [fullName, setFullName] = useState('');
  const [renderFullName, setToRenderFullName] = useState('');

  const webview = {
    listenerFromNative: function(payload) {
      setToRenderFullName(payload);
    }
  };

  useEffect(() => {
    window.webview = webview
  });

  const handleChange = (e) => {
    setFullName(e.target.value);
  };

  const submit = (e) => {
    e.preventDefault();

    if (fullName) {
      if (window.webkit) {
        return window.webkit.messageHandlers.sampleFunction.postMessage(fullName);
      }
    }
  };

  return (
    <div className="App">
      <header className="text-center">React App</header>

      <form className="text-center" id="form">
        <input
          type="text"
          placeholder="Full Name"
          id="full-name"
          onChange={ handleChange }
        />

        <button onClick={ submit }>Submit</button>
      </form>

      <div id="container" className="text-center">
        <div id="text-full-name">
          <small>Full Name:</small>

          <h2>{ renderFullName }</h2>
        </div>
      </div>
    </div>
  );
}

export default App;
