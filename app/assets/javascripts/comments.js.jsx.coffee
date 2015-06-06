jQuery(($) ->
  CommentList = React.createClass
    render: ->
      commentNodes = this.props.data.map (comment) ->
        `<Comment author={comment.author}>
          {comment.content}
        </Comment>`
      `<div className='commentList'>
        {commentNodes}
      </div>`

  CommentForm = React.createClass
    handleSubmit: (e) ->
      e.preventDefault()
      author = React.findDOMNode(this.refs.author).value.trim()
      content = React.findDOMNode(this.refs.content).value.trim()
      if !content || !author
        return
      else
        this.props.onCommentSubmit({author: author, content: content})
        React.findDOMNode(this.refs.author).value = ''
        React.findDOMNode(this.refs.content).value = ''
    render: ->
      `<form className='commentForm' onSubmit={this.handleSubmit}>
        <input type='text' placeholder='Your name' ref='author' />
        <input type='text' placeholder='Say something...' ref='content' />
        <input type='submit' value='Post' />
      </form>`

  Comment = React.createClass
    render: ->
      `<div className='comments'>
        <h2 className='commentAuthor'>
          {this.props.author}
        </h2>
        {this.props.children}
        <hr />
      </div>`

  CommentBox = React.createClass
    loadCommentsFromServer: ->
      $.ajax
        url: this.props.url
        dataType: 'json'
        cache: false
        success: (data) =>
          this.setState({data: data})
        error: (xhr, status, err) =>
          console.error(this.props.url, status, err.toString())
    handleCommentSubmit: (comment) ->
      $.ajax
        url: this.props.url
        dataType: 'json'
        cache: false
        method: 'POST'
        data: {comment: comment}
        success: (data) =>
          this.setState({data: data.push(data)})
        error: (xhr, status, err) =>
          console.error(this.props.url, status, err.toString())
    getInitialState: ->
      {data: []}
    componentDidMount: ->
      this.loadCommentsFromServer()
      setInterval this.loadCommentsFromServer, this.props.pollInterval
    render: ->
      `<div className='commentBox'>
        <h1>Comments</h1>
        <CommentList data={this.state.data}/>
        <CommentForm onCommentSubmit={this.handleCommentSubmit}/>
      </div>`

  React.render `<CommentBox url='comments' pollInterval={2000} />`, $('#content').get(0)
)
