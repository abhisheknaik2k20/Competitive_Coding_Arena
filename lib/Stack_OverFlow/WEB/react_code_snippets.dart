List<String> reactcode_snippets = [
  '''
function Counter() {
  // Initialize state
  const [count, setCount] = React.useState(0);
  
  return React.createElement(
    'div', 
    { className: 'p-6 max-w-sm mx-auto bg-white rounded-xl shadow-lg flex flex-col items-center space-y-4' },
    [
      React.createElement('h2', { className: 'text-2xl font-bold text-purple-700', key: 'title' }, 'React Counter'),
      React.createElement('p', { className: 'text-gray-700', key: 'count' }, `Count: \${count}`),
      React.createElement('div', { className: 'flex space-x-3', key: 'buttons' }, [
        React.createElement(
          'button',
          { 
            className: 'px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700',
            onClick: () => setCount(count + 1),
            key: 'inc-btn'
          },
          'Increment'
        ),
        React.createElement(
          'button',
          { 
            className: 'px-4 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-600',
            onClick: () => setCount(count - 1),
            key: 'dec-btn'
          },
          'Decrement'
        )
      ])
    ]
  );
}

// Example with JSX-style code (you can uncomment this and comment out the above)
/*
function CounterJSX() {
  const [count, setCount] = React.useState(0);
  
  return (
    <div className="p-6 max-w-sm mx-auto bg-white rounded-xl shadow-lg flex flex-col items-center space-y-4">
      <h2 className="text-2xl font-bold text-purple-700">React Counter</h2>
      <p className="text-gray-700">Count: {count}</p>
      <div className="flex space-x-3">
        <button 
          className="px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700"
          onClick={() => setCount(count + 1)}
        >
          Increment
        </button>
        <button 
          className="px-4 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-600"
          onClick={() => setCount(count - 1)}
        >
          Decrement
        </button>
      </div>
    </div>
  );
}
*/
''',
  '''
// Using App as the component name to ensure it's found
function App() {
  const [todos, setTodos] = useState([]);
  const [input, setInput] = useState('');
  
  const addTodo = () => {
    if (input.trim() !== '') {
      setTodos([...todos, { id: Date.now(), text: input, completed: false }]);
      setInput('');
    }
  };
  
  const toggleTodo = (id) => {
    setTodos(todos.map(todo => 
      todo.id === id ? { ...todo, completed: !todo.completed } : todo
    ));
  };
  
  const deleteTodo = (id) => {
    setTodos(todos.filter(todo => todo.id !== id));
  };
  
  return (
    <div className="max-w-md mx-auto p-4">
      <h1 className="text-2xl font-bold mb-4">Todo List</h1>
      
      <div className="flex mb-4">
        <input
          type="text"
          className="flex-1 border border-gray-300 p-2 rounded-l"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyPress={(e) => e.key === 'Enter' && addTodo()}
          placeholder="Add a new task..."
        />
        <button 
          className="bg-green-500 text-white px-4 py-2 rounded-r"
          onClick={addTodo}
        >
          Add
        </button>
      </div>
      
      <ul className="space-y-2">
        {todos.map(todo => (
          <li 
            key={todo.id}
            className="flex items-center justify-between bg-white p-3 rounded shadow"
          >
            <div className="flex items-center">
              <input
                type="checkbox"
                checked={todo.completed}
                onChange={() => toggleTodo(todo.id)}
                className="mr-2"
              />
              <span style={{ textDecoration: todo.completed ? 'line-through' : 'none' }}>
                {todo.text}
              </span>
            </div>
            <button 
              onClick={() => deleteTodo(todo.id)}
              className="text-red-500 hover:text-red-700"
            >
              Delete
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}
 ''',
  '''
 // This will ensure the component is found by using a variable declaration
const App = function() {
  const [isAnimating, setIsAnimating] = useState(false);
  
  return (
    <div className="flex flex-col items-center p-8">
      <motion.div
        animate={{
          rotate: isAnimating ? 360 : 0,
          scale: isAnimating ? 1.5 : 1,
          backgroundColor: isAnimating ? "#ff0088" : "#0099ff"
        }}
        transition={{ duration: 1 }}
        className="w-32 h-32 bg-blue-500 rounded-lg mb-8"
      />
      
      <button
        onClick={() => setIsAnimating(!isAnimating)}
        className="px-4 py-2 bg-purple-600 text-white rounded hover:bg-purple-700"
      >
        {isAnimating ? "Stop Animation" : "Start Animation"}
      </button>
    </div>
  );
}
 ''',
  '''
// Using the MyComponent name that's explicitly checked in your implementation
function MyComponent() {
  const [activeTab, setActiveTab] = useState(1);
  const [content, setContent] = useState('This is the content for Tab 1');
  
  const handleTabChange = (tab) => {
    setActiveTab(tab);
    
    const tabContents = {
      1: "This is the content for Tab 1",
      2: "Tab 2 has different content that appears when selected",
      3: "The third tab shows this custom content"
    };
    
    setContent(tabContents[tab]);
  };
  
  return (
    <div className="max-w-md mx-auto p-4 bg-white rounded shadow">
      <div className="flex border-b">
        {[1, 2, 3].map(tab => (
          <button
            key={tab}
            className={`px-4 py-2 \${activeTab === tab 
              ? 'border-b-2 border-blue-500 text-blue-600' 
              : 'text-gray-600'}`}
            onClick={() => handleTabChange(tab)}
          >
            Tab {tab}
          </button>
        ))}
      </div>
      
      <div className="p-4">
        {content}
      </div>
    </div>
  );
}
 ''',
  '''
// Using the Counter name that's explicitly checked in your implementation
function Counter() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    message: ''
  });
  
  const [errors, setErrors] = useState({});
  const [submitted, setSubmitted] = useState(false);
  
  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value
    });
  };
  
  const validate = () => {
    const newErrors = {};
    
    if (!formData.name.trim()) newErrors.name = "Name is required";
    
    if (!formData.email.trim()) {
      newErrors.email = "Email is required";
    } else if (!/\S+@\S+\.\S+/.test(formData.email)) {
      newErrors.email = "Email is invalid";
    }
    
    if (!formData.message.trim()) newErrors.message = "Message is required";
    
    return newErrors;
  };
  
  const handleSubmit = (e) => {
    e.preventDefault();
    const formErrors = validate();
    
    if (Object.keys(formErrors).length > 0) {
      setErrors(formErrors);
    } else {
      setErrors({});
      setSubmitted(true);
    }
  };
  
  if (submitted) {
    return (
      <div className="max-w-md mx-auto p-6 bg-green-100 rounded-lg text-center">
        <h2 className="text-xl font-bold text-green-800 mb-2">Thank you!</h2>
        <p className="mb-4">Your message has been submitted successfully.</p>
        <button 
          className="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700"
          onClick={() => {
            setFormData({ name: '', email: '', message: '' });
            setSubmitted(false);
          }}
        >
          Send Another Message
        </button>
      </div>
    );
  }
  
  return (
    <div className="max-w-md mx-auto p-6 bg-white rounded-lg shadow-md">
      <h2 className="text-xl font-bold mb-4">Contact Us</h2>
      
      <form onSubmit={handleSubmit}>
        <div className="mb-4">
          <label className="block text-gray-700 mb-2" htmlFor="name">Name</label>
          <input
            type="text"
            id="name"
            name="name"
            value={formData.name}
            onChange={handleChange}
            className={`w-full p-2 border rounded \${errors.name ? 'border-red-500' : 'border-gray-300'}`}
          />
          {errors.name && <p className="text-red-500 text-sm mt-1">{errors.name}</p>}
        </div>
        
        <div className="mb-4">
          <label className="block text-gray-700 mb-2" htmlFor="email">Email</label>
          <input
            type="email"
            id="email"
            name="email"
            value={formData.email}
            onChange={handleChange}
            className={`w-full p-2 border rounded \${errors.email ? 'border-red-500' : 'border-gray-300'}`}
          />
          {errors.email && <p className="text-red-500 text-sm mt-1">{errors.email}</p>}
        </div>
        
        <div className="mb-4">
          <label className="block text-gray-700 mb-2" htmlFor="message">Message</label>
          <textarea
            id="message"
            name="message"
            value={formData.message}
            onChange={handleChange}
            rows="4"
            className={`w-full p-2 border rounded \${errors.message ? 'border-red-500' : 'border-gray-300'}`}
          />
          {errors.message && <p className="text-red-500 text-sm mt-1">{errors.message}</p>}
        </div>
        
        <button 
          type="submit"
          className="w-full bg-blue-500 text-white p-2 rounded hover:bg-blue-600"
        >
          Submit
        </button>
      </form>
    </div>
  );
}
 '''
];
