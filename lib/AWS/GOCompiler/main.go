package main

import (
	"bytes"
	"context"
	"fmt"
	"io/ioutil"
	"os/exec"
	"time"
	"log"
	"os"
	"github.com/aws/aws-lambda-go/lambda"
)

type Event struct {
	Language string `json:"language"`
	Code     string `json:"code"`
}

type Response struct {
	StatusCode int         `json:"StatusCode"`
	Body       interface{} `json:"body"`
}

type ExecutionResult struct {
	Stdout        string `json:"stdout,omitempty"`
	Stderr        string `json:"stderr,omitempty"`
	Error         string `json:"error,omitempty"`
	ExecutionTime string `json:"executionTime"`
}

func handler(ctx context.Context, event Event) (Response, error) {
	log.Printf("Received event: %+v", event)
	var result interface{}
	switch event.Language {
	case "python":
		result = executePythonCode(event.Code)
	case "java":
		result = executeJavaCode(event.Code)
	case "cpp":
		result = executeCppCode(event.Code)
	case "c":
		result = executeCCode(event.Code)
	default:
		result = ExecutionResult{Error: "UNSUPPORTED LANGUAGE"}
	}

	log.Printf("Execution result: %+v", result)

	return Response{
		StatusCode: 200,
		Body:       result,
	}, nil
}
func formatExecutionResult(stdout, stderr, errMsg string, executionTime time.Duration) ExecutionResult {
	return ExecutionResult{
		Stdout:        stdout,
		Stderr:        stderr,
		Error:         errMsg,
		ExecutionTime: fmt.Sprintf("%.2f ms", float64(executionTime.Nanoseconds())/1e6),
	}
}

func executePythonCode(code string) ExecutionResult {
	log.Println("Executing Python code:", code)

	cmd := exec.Command("python3", "-c", code)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	startTime := time.Now()
	err := cmd.Run()
	executionTime := time.Since(startTime)

	log.Printf("Python execution result - Exit Code: %d", cmd.ProcessState.ExitCode())

	if err != nil {
		errorMsg := fmt.Sprintf("Execution error: %v\nStderr: %s", err, stderr.String())
		log.Println(errorMsg)
		return formatExecutionResult("", stderr.String(), errorMsg, executionTime)
	}

	log.Println("Python execution successful")
	return formatExecutionResult(stdout.String(), stderr.String(), "", executionTime)
}

func executeCCode(code string) ExecutionResult {
	fmt.Println("Executing C code:", code)

	// Write the C code to a file
	err := ioutil.WriteFile("/tmp/temp.c", []byte(code), 0644)
	if err != nil {
		return formatExecutionResult("", "", fmt.Sprintf("Failed to write C file: %v", err), 0)
	}

	// Compile the C code
	compileCmd := exec.Command("gcc", "-o", "/tmp/temp", "/tmp/temp.c")
	compileOutput, err := compileCmd.CombinedOutput()
	if err != nil {
		return formatExecutionResult("", string(compileOutput), fmt.Sprintf("Compilation failed: %v\nOutput: %s", err, string(compileOutput)), 0)
	}

	fmt.Printf("C compilation result: %d\n", compileCmd.ProcessState.ExitCode())

	// Run the compiled C program
	runCmd := exec.Command("/tmp/temp")
	var stdout, stderr bytes.Buffer
	runCmd.Stdout = &stdout
	runCmd.Stderr = &stderr

	startTime := time.Now()
	err = runCmd.Run()
	executionTime := time.Since(startTime)

	if err != nil {
		return formatExecutionResult("", stderr.String(), fmt.Sprintf("Execution failed: %v", err), executionTime)
	}

	fmt.Printf("C execution result: %d\n", runCmd.ProcessState.ExitCode())
	return formatExecutionResult(stdout.String(), stderr.String(), "", executionTime)
}

func executeJavaCode(code string) ExecutionResult {
	// Write Java code to file
	err := ioutil.WriteFile("/tmp/Main.java", []byte(code), 0644)
	if err != nil {
		return formatExecutionResult("", "", fmt.Sprintf("Failed to write Java file: %v", err), 0)
	}

	// Compile the Java code
	compileCmd := exec.Command("javac", "/tmp/Main.java")
	compileOutput, err := compileCmd.CombinedOutput()
	if err != nil {
		return formatExecutionResult("", string(compileOutput), fmt.Sprintf("Compilation failed: %v\nOutput: %s", err, string(compileOutput)), 0)
	}

	fmt.Printf("Compilation successful. Exit code: %d\n", compileCmd.ProcessState.ExitCode())

	// Run the compiled Java program
	runCmd := exec.Command("java", "-cp", "/tmp", "Main")
	var stdout, stderr bytes.Buffer
	runCmd.Stdout = &stdout
	runCmd.Stderr = &stderr

	startTime := time.Now()
	err = runCmd.Run()
	executionTime := time.Since(startTime)

	if err != nil {
		return formatExecutionResult("", stderr.String(), fmt.Sprintf("Execution failed: %v", err), executionTime)
	}

	fmt.Printf("Execution successful. Exit code: %d\n", runCmd.ProcessState.ExitCode())
	return formatExecutionResult(stdout.String(), stderr.String(), "", executionTime)
}

func executeCppCode(code string) ExecutionResult {
	fmt.Println("This is the code that we have received:\n", code)

	err := ioutil.WriteFile("/tmp/temp.cpp", []byte(code), 0644)
	if err != nil {
		return formatExecutionResult("", "", err.Error(), 0)
	}

	compileCmd := exec.Command("g++", "/tmp/temp.cpp", "-o", "/tmp/temp")
	compileOutput, err := compileCmd.CombinedOutput()
	if err != nil {
		return formatExecutionResult("", "", string(compileOutput), 0)
	}

	fmt.Println("Compilation result:", compileCmd.ProcessState.ExitCode())

	runCmd := exec.Command("/tmp/temp")
	var stdout, stderr bytes.Buffer
	runCmd.Stdout = &stdout
	runCmd.Stderr = &stderr

	startTime := time.Now()
	err = runCmd.Run()
	executionTime := time.Since(startTime)

	if err != nil {
		return formatExecutionResult("", stderr.String(), err.Error(), executionTime)
	}

	fmt.Println("Run result:", runCmd.ProcessState.ExitCode())
	return formatExecutionResult(stdout.String(), stderr.String(), "", executionTime)
}

func main() {
	log.SetOutput(os.Stderr)
	log.Println("Lambda function starting up")
	lambda.Start(handler)
}