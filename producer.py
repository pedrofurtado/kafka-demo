import cmd

class ProducerCLI(cmd.Cmd):
    intro = 'ProducerCLI. Type "publish_message" now.'
    prompt = '>> '

    def do_publish_message(self, line):
        """Publish a message in Kafka."""
        print("Publish a message in Kafka. We need informations ...")
        key = str(input("Key: ")).strip()
        message = str(input("Message: ")).strip()
        print(f"Key is '{key}' and message is '{message}'")

    def do_exit(self, line):
        """Exit the CLI."""
        return True

if __name__ == '__main__':
    ProducerCLI().cmdloop()
