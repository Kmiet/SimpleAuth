export default function Button({className, disabled, id, onClick, text}) {
  return (
    <button 
      className={className} 
      id={id} 
      onClick={onClick}
      disabled={disabled ? true : false}
      >
      {text}
      </button>
  )
}