import React from 'react';
import './App.css';
import SurveryForm from './SurveyForm';

function App() {
  return (
    <div className="App">
      <div className="App-header">
      <h1> <u> Emotional Responses to Music </u></h1>
      <h4> <i> (Analyzing changes to an individual's emotional state arising from listening to a given music track)</i></h4>
      </div>
      <br/><br/>
      <SurveryForm /> 
    </div>
  );
}

export default App;
