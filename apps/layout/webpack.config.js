module.exports = {
  entry: __dirname + '/login_form/index.js',
  module: {
    rules: [
      { test: /\.js$/, loader: 'babel-loader', exclude: [/node_modules/, /public/] },
      { test: /\.jsx$/, loader: 'babel-loader', exclude: [/node_modules/, /public/] },
      { test: /\.css$/, loader: 'style-loader!css-loader', exclude: [/node_modules/, /public/] }
    ]
  },
  output: {
    filename: 'bundle.js',
    path: __dirname + '/build/login_form'
  },
  externals: {
    "axios": "axios",
    "react": "React",
    "react-dom": "ReactDOM",
    "react-router-dom": "ReactRouterDOM"
  }
};