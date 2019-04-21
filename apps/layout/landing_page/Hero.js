import React, { Fragment } from 'react'
import LandingAnimation from './LandingAnimation';
import Button from '../components/Button';

export default function Hero() {
  return (
    <div id="hero-container">
      <div className="nav-filler"></div>
      <div id="hero-container-row">
        <div id="title-container">
          <p id="main-title">An Identity Provider you seek</p>
          <p id="sub-title">Get your account today!</p>
          <Button id="hero-tryit" text={"Try it out for free"} />
          <Button id="docs" text={"Try it out for free"} />
        </div>
        <LandingAnimation />
      </div>
    </div>
  )
}