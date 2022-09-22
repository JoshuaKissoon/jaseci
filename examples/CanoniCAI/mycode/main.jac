node faq_root;
node faq_state {
    has question;
    has answer;
}

// Static Graph Definition
graph faq {
    has anchor faq_root;
    spawn {
        // Spawn the root node
        faq_root = spawn node::faq_root;

        // Spawn the state nodes
        faq_answer_1 = spawn node::faq_state(
            question="How do I configure my order?",
            answer="To configure your order, log into your Tesla account."
        );
        faq_answer_2 = spawn node::faq_state(
            question="How do I order a tesla?",
            answer="Visit our design studio to place your order."
        );
        faq_answer_3 = spawn node::faq_state(
            question="Can I request a test drive?",
            answer="Yes. You must be a minimum of 25 years of age."
        );

        /**
         * Lets Connect them up... 
         * all of the state nodes to the root node
         */
        faq_root --> faq_answer_1;
        faq_root --> faq_answer_2;
        faq_root --> faq_answer_3;
    }
}

walker init {
    root {
        spawn here --> graph::faq;
        spawn here walker::ask;
    }
}

walker ask {
    has question;

    root {
        question = std.input("AMA > ");
        take --> node::faq_root;
    }
    faq_root {
        take --> node::faq_state(question == question);
    }
    faq_state {:
        std.out(here.answer);
    }
}