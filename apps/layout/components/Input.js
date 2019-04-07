import { Fragment } from 'react'

export default function Input({className, id, label, name, onChange, placeholder, required, type}) {
  return (
    <Fragment>
      <input 
        className={"input " + className ? className : ""} 
        id={id} 
        name={name} 
        type={type === "password" ? "password" : "text"} 
        onChange={onChange}
        placeholder={placeholder} 
        required={required}
        spellCheck={false}
        />
      { label ? (<label>{label}</label>) : "" }
    </Fragment>
  )
}