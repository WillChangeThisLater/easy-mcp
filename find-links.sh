#!/bin/bash

# Find links related to a prompt
#
# Usage:
# ```bash
# ./find-links.sh "critical analysis on a tale of two cities. focus specifically on what two famous critics say. pick one who loved the book and one who hated it"
# ```

set -euo pipefail

references() {

  cat <<'EOF'
  References:

    https://www.how-to-cook.org/basics
    https://www.how-to-cook.org/basics/cutting
    https://www.how-to-cook.org/basics/preparation
    https://www.cookprep.org
EOF
}


good_response() {
  cat <<'EOF'
```good_response
PROMPT: 
Show me how to use the AWS Nova Lite SDK

RESPONSE:
**References:**

1. [Send a message with the Converse API - Amazon Nova](https://docs.aws.amazon.com/nova/latest/userguide/code-examples-converse.html) - The following code examples show how to send a text message to Amazon Nova, using Bedrock's Converse API.
2. [Using the Converse API - Amazon Nova](https://docs.aws.amazon.com/nova/latest/userguide/using-converse-api.html) - One method of invoking the Amazon Nova understanding models (Amazon Nova Micro, Lite, and Pro) is through the Converse API.
3. [Send a message with the ConverseStream API - Amazon Nova](https://docs.aws.amazon.com/nova/latest/userguide/code-examples-conversestream.html) - Shows how to send a text message to Amazon Nova, using Bedrock's Converse API and process the response stream in real-time.
4. [Invoke Amazon Nova on Amazon Bedrock using Bedrock's Converse API](https://docs.aws.amazon.com/code-library/latest/ug/bedrock-runtime_example_bedrock-runtime_Converse_AmazonNovaText_section.html) - AWS SDK Code Examples for invoking Amazon Nova on Amazon Bedrock.
5. [What is Amazon Nova? - Amazon Nova](https://docs.aws.amazon.com/nova/latest/userguide/what-is-nova.html) - Learn about Amazon Nova, a family of multimodal understanding, content creation, and speech-to-speech models.
```
EOF
}

prompt() {

cat <<EOF
I create LLM prompts with bash. Bash makes it easy
for me to compose prompts using dynamic input. Using
  bash, I can reference contents on my local filesystem,
  webpages, etc. It's very useful!

  Something I find myself doing time and again is building a
  references section. The references section is just a big list links to webpages that might be useful for the LLM while answering the question. The references section looks something like this:

  $(references)

  I want you to build this reference section for me. Search the internet to find relevant links to the prompt provided below. When you see an interesting link remember it, and consider reading it so you can see what other pages it links to, and if any of those might be relevant.

  Search for multiple links. Go relatively deep. Try to get a broad, diverse collection of links to help answer the prompt 

  Favor the lynx search tool, which will allow you to both search DuckDuckGo for result as well as get the text content of a web page.

  $(good_response)

  Prompt:
  $1
EOF
}

main() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <prompt>"
    exit 1
  fi
  prompt "$1" | python agent.py --servers lynx | lm-helpers scrape-links
}

main "$@"
