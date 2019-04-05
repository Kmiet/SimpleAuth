import { Fragment } from 'react'

export default function Input({className, id, label, name, onChange, placeholder, required, type}) {
  return (
    <fieldset>
      { label ? (<legend>{label}</legend>) : "" }
      <input 
        className={"input " + className ? className : ""} 
        id={id} 
        name={name} 
        type={type === "password" ? "password" : "text"} 
        onChange={onChange}
        placeholder={placeholder} 
        required={required}
        />
    </fieldset>
  )
}