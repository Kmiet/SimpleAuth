export default function Form({children, error, header}) {
  return (
    <form>
      {header ? <p id="header">{header}</p> : ""}
      {error  ? <p id="error">{error}</p> : ""}
      {children}
    </form>
  )
}