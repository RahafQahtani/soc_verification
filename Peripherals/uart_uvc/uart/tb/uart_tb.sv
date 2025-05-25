class uart_tb extends uvm_env;

    //handle of uart_env
    uart_env m_uart_env;

    //Component macro
    `uvm_component_utils(uart_tb)

    //Class constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "Inside the build phase of uart_tb.", UVM_LOW)
        //Creating the instance of uart_env
        m_uart_env = uart_env::type_id::create("m_uart_env", this);
    endfunction : build_phase

endclass : uart_tb