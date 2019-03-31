import React from 'react'
import { Link } from 'react-router-dom'
import axios from 'axios'

import Form from '../components/Form'
import Input from '../components/Input';
import Button from '../components/Button';

export default class LoginForm extends React.Component {
  constructor() {
    super()
    this.state = { 
      error: "", 
      email: "", 
      password: "" 
    }

    this.handleChange = this.handleChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
  }

  handleChange(event) {
    this.setState({ [event.target.name]: event.target.value })
    console.log(this.state)
  }

  handleSubmit() {
    
  }

  render() {
    return (
      <Form error={this.state.error}>
        <Input 
          label="Email"
          type="email" 
          name="email" 
          onChange={this.handleChange}
          value={this.state.email} 
          />
        <Input 
          label="Password"
          type="password" 
          name="password" 
          onChange={this.handleChange} 
          value={this.state.password} 
          />
        <Button 
          onClick={this.handleSubmit} 
          text="Login" 
          />
      </Form>
    )
  }
}