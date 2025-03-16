List<String> htmlcss_code_snippets = [
  '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flutter iFrame Content</title>
    <style>
        /* Basic Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', sans-serif;
            line-height: 1.6;
            color: #333;
            padding: 20px;
        }
        
        /* Container styling */
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            border-radius: 8px;
            background-color: #f9f9f9;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        /* Header styling */
        .header {
            text-align: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        h1 {
            color: #2196F3;
        }
        
        /* Content sections */
        .section {
            margin-bottom: 20px;
            padding: 15px;
            background-color: white;
            border-radius: 6px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        /* Button styling */
        .button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }
        
        .button:hover {
            background-color: #0d8aee;
        }
        
        /* Form elements */
        input, textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        /* Footer */
        .footer {
            text-align: center;
            margin-top: 30px;
            padding-top: 10px;
            border-top: 1px solid #eee;
            font-size: 0.9em;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Flutter iFrame Content</h1>
            <p>This HTML content is displayed inside an iFrame in a Flutter web app</p>
        </div>
        
        <div class="section">
            <h2>Basic Section</h2>
            <p>This is a basic content section that can be styled differently from your Flutter app.</p>
        </div>
        
        <div class="section">
            <h2>Interactive Elements</h2>
            <button class="button" onclick="document.getElementById('message').innerHTML = 'Button was clicked!'">Click Me</button>
            <p id="message" style="margin-top: 10px;"></p>
        </div>
        
        <div class="section">
            <h2>Form Example</h2>
            <form id="sampleForm">
                <input type="text" placeholder="Your name" id="nameInput">
                <textarea placeholder="Your message" rows="4"></textarea>
                <button type="button" class="button" onclick="handleFormSubmit()">Submit</button>
            </form>
        </div>
        
        <div class="footer">
            &copy; 2025 Flutter Web App Demo
        </div>
    </div>

    <script>
        // Simple function to demonstrate JavaScript interaction
        function handleFormSubmit() {
            const name = document.getElementById('nameInput').value;
            if (name) {
                document.getElementById('message').innerHTML = 'Thank you, ' + name + '! Your message has been received.';
            } else {
                document.getElementById('message').innerHTML = 'Please enter your name.';
            }
        }
        
        // Function to communicate with Flutter
        function sendToFlutter(message) {
            // This will only work if you've set up the appropriate message channel in Flutter
            if (window.parent) {
                window.parent.postMessage(message, '*');
            }
        }
        
        // Listen for messages from Flutter
        window.addEventListener('message', function(event) {
            document.getElementById('message').innerHTML = 'Message from Flutter: ' + event.data;
        });
    </script>
</body>
</html> 
  ''',
  '''
  <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Animated Cards</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }
        
        .card-container {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            justify-content: center;
            max-width: 1000px;
        }
        
        .card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 220px;
            transition: transform 0.3s, box-shadow 0.3s;
            animation: fadeIn 0.8s ease-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .card:nth-child(1) { animation-delay: 0.1s; }
        .card:nth-child(2) { animation-delay: 0.2s; }
        .card:nth-child(3) { animation-delay: 0.3s; }
        .card:nth-child(4) { animation-delay: 0.4s; }
        
        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
        }
        
        .card-icon {
            width: 60px;
            height: 60px;
            background-color: #e3f2fd;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            color: #1976d2;
            font-size: 24px;
        }
        
        .card h3 {
            margin: 0 0 10px;
            color: #333;
        }
        
        .card p {
            margin: 0;
            color: #666;
            font-size: 0.9rem;
            line-height: 1.5;
        }
    </style>
</head>
<body>
    <div class="card-container">
        <div class="card">
            <div class="card-icon">📊</div>
            <h3>Analytics</h3>
            <p>Track your performance with our comprehensive analytics dashboard.</p>
        </div>
        <div class="card">
            <div class="card-icon">🔒</div>
            <h3>Security</h3>
            <p>Enterprise-grade security to keep your data safe and protected.</p>
        </div>
        <div class="card">
            <div class="card-icon">⚡</div>
            <h3>Performance</h3>
            <p>Lightning fast speeds with optimized backend infrastructure.</p>
        </div>
        <div class="card">
            <div class="card-icon">🔄</div>
            <h3>Sync</h3>
            <p>Real-time synchronization across all your devices.</p>
        </div>
    </div>
</body>
</html> 
  ''',
  '''
  <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Animated Progress</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }
        
        .progress-container {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            padding: 30px;
            width: 80%;
            max-width: 500px;
        }
        
        h2 {
            color: #333;
            text-align: center;
            margin-top: 0;
        }
        
        .progress-item {
            margin-bottom: 25px;
        }
        
        .progress-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .progress-bar {
            height: 10px;
            background-color: #e0e0e0;
            border-radius: 5px;
            overflow: hidden;
        }
        
        .progress-fill {
            height: 100%;
            width: 0%;
            border-radius: 5px;
            transition: width 1.5s ease-in-out;
        }
        
        .progress-fill.design { background-color: #4caf50; }
        .progress-fill.development { background-color: #2196f3; }
        .progress-fill.marketing { background-color: #ff9800; }
        .progress-fill.revenue { background-color: #9c27b0; }
    </style>
</head>
<body>
    <div class="progress-container">
        <h2>Project Progress</h2>
        
        <div class="progress-item">
            <div class="progress-label">
                <span>Design</span>
                <span>85%</span>
            </div>
            <div class="progress-bar">
                <div class="progress-fill design" id="design"></div>
            </div>
        </div>
        
        <div class="progress-item">
            <div class="progress-label">
                <span>Development</span>
                <span>70%</span>
            </div>
            <div class="progress-bar">
                <div class="progress-fill development" id="development"></div>
            </div>
        </div>
        
        <div class="progress-item">
            <div class="progress-label">
                <span>Marketing</span>
                <span>45%</span>
            </div>
            <div class="progress-bar">
                <div class="progress-fill marketing" id="marketing"></div>
            </div>
        </div>
        
        <div class="progress-item">
            <div class="progress-label">
                <span>Revenue</span>
                <span>30%</span>
            </div>
            <div class="progress-bar">
                <div class="progress-fill revenue" id="revenue"></div>
            </div>
        </div>
    </div>
    
    <script>
        // Animate progress bars on page load
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(() => {
                document.getElementById('design').style.width = '85%';
                document.getElementById('development').style.width = '70%';
                document.getElementById('marketing').style.width = '45%';
                document.getElementById('revenue').style.width = '30%';
            }, 300);
        });
    </script>
</body>
</html>

  ''',
  '''
  <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Animated Login</title>
    <style>
        body {
            font-family: 'Nunito', sans-serif;
            background-color: #f5f7fa;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        
        .login-container {
            width: 320px;
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transform: translateY(20px);
            opacity: 0;
            animation: slideUp 0.8s forwards;
        }
        
        @keyframes slideUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .login-header {
            background: linear-gradient(45deg, #6a11cb, #2575fc);
            padding: 30px 20px;
            text-align: center;
            color: white;
        }
        
        .login-header h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
        }
        
        .login-form {
            padding: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            color: #555;
            font-weight: 600;
        }
        
        input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 15px;
            transition: all 0.3s;
            box-sizing: border-box;
        }
        
        input:focus {
            border-color: #2575fc;
            outline: none;
            box-shadow: 0 0 0 3px rgba(37, 117, 252, 0.2);
        }
        
        .login-button {
            background: linear-gradient(45deg, #6a11cb, #2575fc);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 14px;
            width: 100%;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }
        
        .login-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(37, 117, 252, 0.3);
        }
        
        .forgot-password {
            text-align: center;
            margin-top: 15px;
            font-size: 14px;
        }
        
        .forgot-password a {
            color: #2575fc;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1>Welcome Back</h1>
        </div>
        <div class="login-form">
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" placeholder="Enter your email">
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" placeholder="Enter your password">
            </div>
            <button class="login-button">Log In</button>
            <div class="forgot-password">
                <a href="#">Forgot your password?</a>
            </div>
        </div>
    </div>
</body>
</html>
  ''',
];
