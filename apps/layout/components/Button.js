export default function Button({className, id, onClick, text}) {
  return (
    <button 
      className={className} 
      id={id} 
      onClick={onClick}
      >
      {text}
      </button>
  )
}