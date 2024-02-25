<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Expense;

class ExpenseController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $user_id = $request->user()->id;
        $expenses = Expense::where('user_id', $user_id)->paginate(10);
    
        return response()->json([
            "expenses" => $expenses,
        ], 200);
    }
    
    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'amount' => 'required|numeric',
            'description' => 'required|max:150',
            'date' => 'required',
            'category' => 'nullable|string',
            'spent' => 'bool'
        ]);
    
        $expense = Expense::create([
            'amount' => $request->amount,
            'description' => $request->description,
            'date' => $request->date,
            'category' => $request->category,
            'spent' => $request->spent,
            'user_id' => $request->user()->id,
        ]);
    
        return response()->json([
            "message" => "Successfully added expense!",
            "expense" => $expense,
        ], 200);
    }
    

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $expense = Expense::findOrFail($id);
    
        if ($expense->user_id != request()->user()->id) {
            abort(403, "Unauthorized.");
        }
    
        return response()->json($expense, 200);
    }
    

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        // Validate input
        $request->validate([
            'amount' => 'numeric',
            'description' => 'string',
            'date' => 'date',
            'category' => 'nullable|string',
            'spent' => 'bool'
        ]);
    
        try {
            // Find the expense by ID
            $expense = Expense::findOrFail($id);
    
            // Update the expense
            $expense->update([
                'amount' => $request->amount ? $request->amount : $expense->amount,
                'description' =>  $request->description ? $request->description : $expense->description,
                'date' => $request->date ? $request->date : $expense->date,
                'category' => $request->category ? $request->category : $expense->category,
                'spent' => $request->spent,
            ]);
    
            // Return success response
            return response()->json([
                "message" => "Expense updated!",
                "data" => $expense,
            ], 200);
        } catch (\Exception $e) {
            // Return error response if expense is not found
            return response()->json([
                "message" => "Expense not found.",
                "error" => $e->getMessage(), // Include the error message for debugging
            ], 404);
        }
    }
    
    

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $expense = Expense::findOrFail($id);
        $expense->delete();
    
        return response()->json([
            "message" => "Record deleted successfully!",
            "deleted_expense" => $expense, 
        ], 200);
    }
    
}
